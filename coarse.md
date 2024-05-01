                boolean add(Node node) {
Init:               lock.lock();
Locked:             prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
AddCheck:           if (curr.key == node.key) {
                        lock.unlock();
AddFalse:               return false;
                    } else {
Add1:                   node.next = curr;
Add2:                   prev.next = node;
                        lock.unlock();
AddTrue:                return true;
                    }
                }

                boolean remove(Node node) {
Init:               lock.lock();
Locked:             prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
RemoveCheck:        if (curr.key == node.key) {
Remove:                 prev.next = curr.next;
                        lock.unlock();
RemoveTrue:             return true;
                    } else {
                        lock.unlock();
RemoveFalse:            return false;
                    }
                }

                boolean contains(Node node) {
Init:               lock.lock();
Locked:             prev = head;
                    curr = head.next;
TraversalCheck:     while (curr.key < node.key) {
Traversal:              prev = curr;
                        curr = curr.next;
                    }
Contains:           if (curr.key == node.key) {
                        lock.unlock();
ContainsTrue:           return true;
                    } else {
                        lock.unlock();
ContainsFalse:          return false;
                    }
                }
