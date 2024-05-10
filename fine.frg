#lang forge/temporal

option max_tracelength 25

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
    var next: one Node,
    var owner: lone Thread
}
one sig Head extends Node {}
one sig Tail extends Node {}

-- Each thread's ip can be at one of these points in the code at each timestep
abstract sig Label {}
-- Traversal is the first part of all three methods
one sig Init, HeadLocked extends Label {}
one sig TraversalCheck, Traversal1, Traversal2 extends Label {}
one sig AddCheck, Add1, Add2, AddFalse, AddTrue extends Label {}
one sig RemoveCheck, Remove, RemoveFalse, RemoveTrue extends Label {}
one sig Contains, ContainsFalse, ContainsTrue extends Label {}


pred canProceed[t: Thread] {
    -- You cannot proceed until the node is available to lock
    (t.ip = Init) => no Head.owner
    (t.ip = HeadLocked) => no Head.next.owner
    (t.ip = Traversal2) => no t.curr.next.owner
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
    t.ip' = HeadLocked
    t.prev' = Head
    -- The only change to owner is that the current thread now owns t.prev
    owner' = owner + (Head -> t)
    -- Frame
    t.curr' = t.curr
    next' = next
}

pred deltaHeadLocked[t: Thread] {
    -- Guard
    t.ip = HeadLocked
    -- Action
    t.ip' = TraversalCheck
    t.curr' = Head.next
    -- The only change to owner is that the current thread now owns t.curr
    owner' = owner + (Head.next -> t)
    -- Frame
    t.prev' = t.prev
    next' = next
}

pred deltaTraversalCheck[t: Thread] {
    -- Guard
    t.ip = TraversalCheck
    canProceed[t]
    -- Action
    (t.curr.key < t.node.key) implies {
        t.ip' = Traversal1
    } else {
        -- The thread can move to any of these labels depending on which
        -- method it's running
        t.ip' in { AddCheck + RemoveCheck + Contains }
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
    owner' = owner
}

pred deltaTraversal1[t: Thread] {
    -- Guard
    t.ip = Traversal1
    canProceed[t]
    -- Action
    t.ip' = Traversal2
    -- The only change to owner is that t.prev is now unlocked
    owner' = owner - (t.prev -> t)
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred deltaTraversal2[t: Thread] {
    -- Guard
    t.ip = Traversal2
    canProceed[t]
    -- Action
    t.ip' = TraversalCheck
    t.prev' = t.curr
    t.curr' = t.curr.next
    -- The only change to owner is that the current thread now owns t.curr
    owner' = owner + (t.curr.next -> t)
    -- Frame
    next' = next
}

pred deltaAddCheck[t: Thread] {
    -- Guard
    t.ip = AddCheck
    canProceed[t]
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = AddFalse
        -- Unlock nodes that are still held
        owner' = owner - (t.prev -> t) - (t.curr -> t)
    } else {
        t.ip' = Add1
        owner' = owner
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
    owner' = owner
}

pred deltaAdd2[t: Thread] {
    -- Guard
    t.ip = Add2
    canProceed[t]
    -- Action
    t.ip' = AddTrue
    -- The only change to next is that t.prev now points to t.node
    (next' - next) = (t.prev -> t.node)
    -- Unlock nodes that are still held
    owner' = owner - (t.prev -> t) - (t.curr -> t)
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
        owner' = owner
    } else {
        t.ip' = RemoveFalse
        -- Unlock nodes that are still held
        owner' = owner - (t.prev -> t) - (t.curr -> t)
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
    -- Unlock nodes that are still held
    owner' = owner - (t.prev -> t) - (t.curr -> t)
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
    -- Unlock nodes that are still held
    owner' = owner - (t.prev -> t) - (t.curr -> t)
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
    -- All nodes start unlocked
    no Node.owner
}

pred delta {
    (some t: Thread | canProceed[t]) implies {
        some t: Thread | {
            deltaInit[t] or deltaHeadLocked[t] or deltaTraversalCheck[t]
            or deltaTraversal1[t] or deltaTraversal2[t]
            or deltaAddCheck[t] or deltaAdd1[t] or deltaAdd2[t]
            or deltaRemoveCheck[t] or deltaRemove[t]
            or deltaContains[t]
            all u: Thread - t | doNothing[u]
        }
    } else {
        all t: Thread | doNothing[t]
        next' = next
        owner' = owner
    }
}

run {
    init and always delta
    some disj t1, t2: Thread | {
        eventually {
            t1.ip = Traversal2 and t2.ip = Traversal2
        }
        eventually {
            t1.ip = AddTrue and t2.ip = ContainsTrue
        }
        t1.node = t2.node
    }
} for 8 Node, exactly 2 Thread
