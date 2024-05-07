#lang forge/temporal
open "coarse.frg"

option max_tracelength 12

pred algorithm {
    init and always delta
}

pred alwaysOrderedByKey {
    always {
        all n: Head.(^next) | n.key <= n.next.key
    }
}

assert algorithm is sufficient for alwaysOrderedByKey for 4 Node, 2 Thread
