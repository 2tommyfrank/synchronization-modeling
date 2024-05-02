#lang forge/temporal

option max_tracelength 20

sig Thread {
    -- Instruction pointer
    var ip: one Label,
    -- Arguments to the method being run by the thread (happen to be the same
    -- for all methods: just the node to add, remove, or check for containment)
    node: one Node,
    -- Local variables (happen to be the same for all methods)
    var prev: one Node,
    var curr: one Node
}

sig Node {
    -- Represents the hash of the item in the node
    key: one Int,
    -- Shared variables, cached locally by each thread
    var next: one Node
}
one sig Head extends Node {}
one sig Tail extends Node {}

one sig Lock {
    var owner: lone Thread
}

-- Each thread's ip can be at one of these points in the code at each timestep
abstract sig Label {}
-- Traversal is the first part of all three methods
one sig Init, Locked, TraversalCheck, Traversal extends Label {}
one sig AddCheck, Add1, Add2, AddFalse, AddTrue extends Label {}
one sig RemoveCheck, Remove, RemoveFalse, RemoveTrue extends Label {}
one sig Contains, ContainsFalse, ContainsTrue extends Label {}


pred canProceed[t: Thread] {
    -- You cannot proceed from Init until you can acquire the lock
    (t.ip = Init) => no Lock.owner
    -- You cannot proceed from a return statement (there is no next step)
    t.ip not in {
        AddFalse + AddTrue + RemoveFalse + RemoveTrue
        + ContainsFalse + ContainsTrue
    }
}


pred deltaInit[t: Thread] {
    -- Guard
    t.ip = Init
    canProceed[t]
    -- Action
    t.ip' = Locked
    Lock.owner' = t
    -- Frame
    t.prev' = Head
    t.curr' = Head.next
    next' = next
}

pred deltaLocked[t: Thread] {
    -- Guard
    t.ip = Locked
    canProceed[t]
    -- Action
    t.ip' = TraversalCheck
    t.prev' = Head
    t.curr' = Head.next
    -- Frame
    next' = next
    Lock.owner' = Lock.owner
}

pred deltaTraversalCheck[t: Thread] {
    -- Guard
    t.ip = TraversalCheck
    canProceed[t]
    -- Action
    (t.curr.key < t.node.key) implies {
        t.ip' = Traversal
    } else {
        -- The thread can move to any of these labels depending on which
        -- method it's running
        t.ip' in { AddCheck + RemoveCheck + Contains }
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
    Lock.owner' = Lock.owner
}

pred deltaTraversal[t: Thread] {
    -- Guard
    t.ip = Traversal
    canProceed[t]
    -- Action
    t.ip' = TraversalCheck
    t.prev' = t.curr
    t.curr' = t.curr.next
    -- Frame
    next' = next
    Lock.owner' = Lock.owner
}

pred deltaAddCheck[t: Thread] {
    -- Guard
    t.ip = AddCheck
    canProceed[t]
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = AddFalse
        no Lock.owner'
    } else {
        t.ip' = Add1
        Lock.owner' = Lock.owner
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred deltaAdd1[t: Thread] {
    -- Guard
    t.ip = Add1
    canProceed[t]
    -- Action
    t.ip' = Add2
    -- The only change to next is that t.node now points to t.curr
    (next' - next) = (t.node -> t.curr)
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    Lock.owner' = Lock.owner
}

pred deltaAdd2[t: Thread] {
    -- Guard
    t.ip = Add2
    canProceed[t]
    -- Action
    t.ip' = AddTrue
    -- The only change to next is that t.prev now points to t.node
    (next' - next) = (t.prev -> t.node)
    no Lock.owner'
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
}

pred deltaRemoveCheck[t: Thread] {
    -- Guard
    t.ip = RemoveCheck
    canProceed[t]
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = Remove
        Lock.owner' = Lock.owner
    } else {
        t.ip' = RemoveFalse
        no Lock.owner'
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred deltaRemove[t: Thread] {
    -- Guard
    t.ip = Remove
    canProceed[t]
    -- Action
    t.ip' = RemoveTrue
    -- The only change to next is that t.prev now points to t.curr.next
    (next' - next) = (t.prev -> t.curr.next)
    no Lock.owner'
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
}

pred deltaContains[t: Thread] {
    -- Guard
    t.ip = Contains
    canProceed[t]
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = ContainsTrue
    } else {
        t.ip' = ContainsFalse
    }
    no Lock.owner'
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred doNothing[t: Thread] {
    -- Frame: This thread's local variables stay the same
    t.ip' = t.ip
    t.prev' = t.prev
    t.curr' = t.curr
}


pred init {
    Thread.ip = Init
    -- All keys are unique
    no disj a, b: Node | a.key = b.key
    -- Head key is minimum, tail key is maximum
    Head.key = min[Int]
    Tail.key = max[Int]
    -- Cannot try to add/remove head or tail
    all t: Thread | t.node not in { Head + Tail }
    -- Keys are in ascending order in the list
    all n: Head.(^next) | n.key <= n.next.key
    -- Tail's next field points to itself (so next can be a total function)
    Tail.next = Tail
    -- Tail is reachable from Head
    (Head -> Tail) in ^next
    -- The lock starts unlocked
    no Lock.owner
}

pred delta {
    (some t: Thread | canProceed[t]) implies {
        some t: Thread | {
            deltaInit[t] or deltaLocked[t] or deltaTraversalCheck[t]
            or deltaTraversal[t]
            or deltaAddCheck[t] or deltaAdd1[t] or deltaAdd2[t]
            or deltaRemoveCheck[t] or deltaRemove[t]
            or deltaContains[t]
            all u: Thread - t | doNothing[u]
        }
    } else {
        all t: Thread | doNothing[t]
        next' = next
        Lock.owner' = Lock.owner
    }
}

run {
    init
    always delta
    eventually { some t: Thread | t.ip = AddTrue }
} for 8 Node, exactly 2 Thread

run { init and always delta } for 8 Node, exactly 2 Thread
