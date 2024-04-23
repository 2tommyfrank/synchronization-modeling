#lang forge/temporal

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

-- Each thread's ip can be at one of these points in the code at each timestep
abstract sig Label {}
-- Traversal is the first part of all three methods
one sig Init, TraversalCheck, Traversal extends Label {}
one sig AddCheck, Add1, Add2, AddFalse, AddTrue extends Label {}
one sig RemoveCheck, Remove, RemoveFalse, RemoveTrue extends Label {}
one sig Contains, ContainsFalse, ContainsTrue extends Label {}


pred deltaInit[t: Thread] {
    -- Guard
    t.ip = Init
    -- Action
    t.ip' = TraversalCheck
    t.prev' = Head
    t.curr' = Head.next
    -- Frame
    next' = next
}

pred deltaTraversalCheck[t: Thread] {
    -- Guard
    t.ip = TraversalCheck
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
}

pred deltaTraversal[t: Thread] {
    -- Guard
    t.ip = Traversal
    -- Action
    t.ip' = TraversalCheck
    t.prev' = t.curr
    t.curr' = t.curr.next
    -- Frame
    next' = next
}

pred deltaAddCheck[t: Thread] {
    -- Guard
    t.ip = AddCheck
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = AddFalse
    } else {
        t.ip' = Add1
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred deltaAdd1[t: Thread] {
    -- Guard
    t.ip = Add1
    -- Action
    t.ip' = Add2
    -- The only change to next is that t.node now points to t.curr
    (next' - next) = (t.node -> t.curr)
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
}

pred deltaAdd2[t: Thread] {
    -- Guard
    t.ip = Add2
    -- Action
    t.ip' = AddTrue
    -- The only change to next is that t.prev now points to t.node
    (next' - next) = (t.prev -> t.node)
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
}

pred deltaRemoveCheck[t: Thread] {
    -- Guard
    t.ip = RemoveCheck
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = Remove
    } else {
        t.ip' = RemoveFalse
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred deltaRemove[t: Thread] {
    -- Guard
    t.ip = Remove
    -- Action
    t.ip' = RemoveTrue
    -- The only change to next is that t.prev now points to t.curr.next
    (next' - next) = (t.prev -> t.curr.next)
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
}

pred deltaContains[t: Thread] {
    -- Guard
    t.ip = Contains
    -- Action
    (t.curr.key = t.node.key) implies {
        t.ip' = ContainsTrue
    } else {
        t.ip' = ContainsFalse
    }
    -- Frame
    t.prev' = t.prev
    t.curr' = t.curr
    next' = next
}

pred doNothing {
    -- Guard: all the threads are at a return label
    Thread.ip in {
        AddFalse + AddTrue
        + RemoveFalse + RemoveTrue
        + ContainsFalse + ContainsTrue
    }
    -- Frame: everything stays the same
    ip' = ip and prev' = prev and curr' = curr and next' = next
}


pred init {
    Thread.ip = Init
    -- All keys are unique
    no disj a, b: Node | a.key = b.key
    -- Head has the lowest key (given that all keys are unique)
    Head.key <= Node.key
    -- Tail has the highest key (given that all keys are unique)
    Tail.key >= Node.key
    -- Tail's next field points to itself (so next can be a total function)
    Tail.next = Tail
    -- Tail is reachable from Head
    (Head -> Tail) in ^next
}

pred delta {
    some t: Thread | {
        deltaInit[t] or deltaTraversalCheck[t] or deltaTraversal[t]
        or deltaAddCheck[t] or deltaAdd1[t] or deltaAdd2[t]
        or deltaRemoveCheck[t] or deltaRemove[t]
        or deltaContains[t]
    }
    or doNothing
}

run { init and always delta } for 8 Node, exactly 2 Thread
