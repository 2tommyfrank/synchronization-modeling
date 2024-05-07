#lang forge/temporal
open "coarse.frg"

option max_tracelength 25
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
pred alwayTailReachable{
    always {
        (Head -> Tail) in ^next
        Tail.next = Tail
    }
}

pred eventuallyComplete{
    eventually {
        Thread.ip  in {
        AddFalse + AddTrue + RemoveFalse + RemoveTrue
        + ContainsFalse + ContainsTrue
    }
    }
}

test expect {
    linearizability1 : {
        some disj t1, t2: Thread | {
            algorithm
            eventually t1.ip = AddTrue
            eventually t2.ip = Contains
            (t2.ip = Init) until (t1.ip = AddTrue)
            t1.node = t2.node
            always t2.ip != ContainsTrue
            no t: Thread | {
                eventually t.ip = RemoveTrue
                t.node = t1.node
            }
        }
    } for 4 Node, exactly 3 Thread is unsat
}

// assert algorithm is sufficient for alwaysOrderedByKey for 4 Node, 2 Thread
// assert algorithm is sufficient for alwayTailReachable for 4 Node, 2 Thread
// assert algorithm is sufficient for eventuallyComplete for 4 Node, 2 Thread



