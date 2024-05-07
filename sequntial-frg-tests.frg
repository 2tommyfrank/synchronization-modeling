#lang forge/temporal
open "sequential.frg"

// pred init {
//     Thread.ip = Init
//     -- All keys are unique
//     no disj a, b: Node | a.key = b.key
//     -- Head key is minimum, tail key is maximum
//     Head.key = min[Int]
//     Tail.key = max[Int]
//     -- Keys are in ascending order in the list
//     all n: Head.(^next) | n.key <= n.next.key
//     -- Tail's next field points to itself (so next can be a total function)
//     Tail.next = Tail
//     -- Tail is reachable from Head
//     (Head -> Tail) in ^next
// }

pred tail_unreachable{
    //Thread.ip = Init
    (Head -> Tail) not in ^next
}
pred cyclical_list{
    Thread.ip = Init
    Tail.next = Head
    (Head -> Head) in ^next
}
pred unordered_keys{
    Thread.ip = Init
    Head.key = min[Int]
    Tail.key = max[Int]
    all n: Head.(^next) | n.key > n.next.key 
}
pred unique_keys{
    Thread.ip = Init
    // no disj a, b: Node | a.key = b.key

    all a: Node |{
        no b: Node |{
        a != b
        a.key = b.key
        }
    }
}


test suite for init {
    
     test expect {
        valid_init:
        //init state is valid
        {tail_unreachable init} is unsat
        {cyclical_list init} is unsat
        {unordered_keys init} is unsat
        {unique_keys init} is sat 
    }

}

pred delta {
    (some t: Thread | canProceed[t]) implies {
        some t: Thread | {
            deltaInit[t] or deltaTraversalCheck[t] or deltaTraversal[t]
            or deltaAddCheck[t] or deltaAdd1[t] or deltaAdd2[t]
            or deltaRemoveCheck[t] or deltaRemove[t]
            or deltaContains[t]
            all u: Thread - t | doNothing[u]
        }
    } else {
        all t: Thread | doNothing[t]
        next' = next
    }
}