#lang forge/temporal
open "unsynchronized.frg"

option max_tracelength 20
option solver Glucose

pred algorithm {
    init and always delta
}
-- Keys are always in order
pred alwaysOrderedByKey {
    always {
        all n: Head.(^next) | n.key <= n.next.key
    }
}
-- Tail is always reachable by Head
pred alwayTailReachable {
    always {
        (Head -> Tail) in ^next
        Tail.next = Tail
    }
}

pred eventuallyComplete {
    eventually {
        Thread.ip in {
            AddFalse + AddTrue + RemoveFalse + RemoveTrue
            + ContainsFalse + ContainsTrue
        }
    }
}

test expect {
    // if add returns True, then contains should return True - FAILURE
    // linearizabilityAddContains : {
    //     some disj t1, t2: Thread | {
    //         algorithm
    //         eventually t1.ip = AddTrue
    //         eventually t2.ip = Contains
    //         (t2.ip = Init) until (t1.ip = AddTrue)
    //         t1.node = t2.node
    //         always t2.ip != ContainsTrue
    //         no t: Thread | {
    //             eventually t.ip = RemoveTrue
    //             t.node = t1.node
    //         }
    //     }
    // } for 4 Node, exactly 3 Thread is unsat

    // if remove returns True, then contains should return False - FAILURE
    // linearizabilityRemoveContains : {
    //     some disj t1, t2: Thread | {
    //         algorithm
    //         eventually t1.ip = RemoveTrue
    //         eventually t2.ip = Contains
    //         (t2.ip = Init) until (t1.ip = RemoveTrue)
    //         t1.node = t2.node
    //         always t2.ip != ContainsFalse
    //         no t: Thread | {
    //             eventually t.ip = AddTrue
    //             t.node = t1.node
    //         }
    //     }
    // } for 4 Node, exactly 3 Thread is unsat

    // if contains returns False, then add should return True
    linearizabilityContainsAdd : {
        some disj t1, t2: Thread | {
            algorithm
            eventually t1.ip = ContainsFalse
            eventually t2.ip = AddCheck
            (t2.ip = Init) until (t1.ip = ContainsFalse)
            t1.node = t2.node
            always t2.ip != AddTrue
            no t: Thread - t2 | {
                eventually t.ip = AddTrue
                t.node = t1.node
            }
        }
    } for 4 Node, exactly 3 Thread is unsat

    // if contains returns True, then remove should return True
    linearizabilityContainsRemove : {
        some disj t1, t2: Thread | {
            algorithm
            eventually t1.ip = ContainsTrue
            eventually t2.ip = RemoveCheck
            (t2.ip = Init) until (t1.ip = ContainsTrue)
            t1.node = t2.node
            always t2.ip != RemoveTrue
            no t: Thread - t2 | {
                eventually t.ip = RemoveTrue
                t.node = t1.node
            }
        }
    } for 4 Node, exactly 3 Thread is unsat
}

assert algorithm is sufficient for alwaysOrderedByKey for 4 Node, 2 Thread
assert algorithm is sufficient for alwayTailReachable for 4 Node, 2 Thread
assert algorithm is sufficient for eventuallyComplete for 4 Node, 2 Thread
