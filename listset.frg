#lang forge/temporal

sig Thread {
    var state: one State,
    var prev: some Node,
    var curr: some Node,
}

sig Node {
    key: one Int,
    var next: pfunc Thread -> Node,
}

one sig Head extends Node {}

abstract sig State {}
abstract sig AddState, RemoveState, ContainsState extends State {}

sig AddInit, Add1, Add2, Add3, Add4, Add5, Add6, AddFalse, AddTrue extends AddState {}
sig RemoveInit, Remove1, Remove2, Remove3, Remove4, Remove5, RemoveFalse, RemoveTrue extends AddState {}
sig ContainsInit, Contains1, Contains2, Contains3, Contains4, ContainsFalse, ContainsTrue extends AddState {}

pred init[t: Thread] {
    t.state = AddInit or t.state = RemoveInit or t.state = ContainsInit
}

//TODO: need to make sure everything else stays the same

pred deltaAdd1[t: Thread, n: Node] {
    {
        t.state = AddInit
        next_state {
            t.state = Add1
            t.prev = Head
            t.curr = Head.next[t]
        }
    }
    or
    {
        t.state = Add3
        next_state {
            t.state = Add1
            t.curr = t.curr.next
        }
    }
}

pred deltaAdd2[t: Thread, n: Node] {
    t.state = Add1
    t.curr.key < n.key
    next_state { t.state = Add2 }
}

pred deltaAdd3[t: Thread, n: Node] {
    t.state = Add2
    next_state {
        t.state = Add3
        t.prev = t.curr
    }
}

pred deltaAdd4[t: Thread, n: Node] {
    t.state = Add3
    t.curr.key >= n.key
    next_state { t.state = Add4}
}

pred deltaAddFalse[t: Thread, n: Node] {
    t.state = Add4
    t.curr.key = n.key
    next_state { t.state = AddFalse }
}

pred deltaAdd5[t: Thread, n: Node] {
    t.state = Add4
    t.curr.key != n.key
    next_state { t.state = Add5 }
}

pred deltaAdd6[t: Thread, n: Node] {
    t.state = Add5
    next_state {
        t.state = Add6
        n.next = t.curr
    }
}

pred deltaAddTrue[t: Thread, n: Node] {
    t.state = Add6
    next_state {
        t.state = AddTrue
        t.prev.next = n
    }
}
