                boolean add(Node node) {
Init:               prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
AddCheck:           if (curr.key == node.key) {
AddFalse:               return false;
                    } else {
Add1:                   node.next = curr;
Add2:                   prev.next = node;
AddTrue:                return true;
                    }
                }

                boolean remove(Node node) {
Init:               prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
RemoveCheck:        if (curr.key == node.key) {
Remove:                 prev.next = curr.next;
RemoveTrue:             return true;
                    } else {
RemoveFalse:            return false;
                    }
                }

                boolean contains(Node node) {
Init:               prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
Contains:           if (curr.key == node.key) {
ContainsTrue:           return true;
                    } else {
ContainsFalse:          return false;
                    }
                }
