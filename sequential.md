boolean add(Node node) {
    AddInit:
    prev = head;
    curr = head.next;
    Add1:
    while (curr.key < node.key) {
        Add2:
        prev = curr;
        Add3:
        curr = curr.next;
    }
    Add4:
    if (curr.key == node.key) {
        AddFalse:
        return false;
    } else {
        Add5:
        node.next = curr;
        Add6:
        prev.next = node;
        AddTrue:
        return true;
    }
}

boolean remove(Node node) {
    RemoveInit:
    prev = head;
    curr = head.next;
    Remove1:
    while (curr.key < node.key) {
        Remove2:
        prev = curr;
        Remove3:
        curr = curr.next;
    }
    Remove4:
    if (curr.key == node.key) {
        Remove5:
        prev.next = curr.next;
        RemoveTrue:
        return true;
    } else {
        RemoveFalse:
        return false;
    }
}

boolean contains(Node node) {
    ContainsInit:
    prev = head;
    curr = head.next;
    Contains1:
    while (curr.key < node.key) {
        Contains2:
        prev = curr;
        Contains3:
        curr = curr.next;
    }
    Contains4:
    if (curr.key == node.key) {
        ContainsTrue:
        return true;
    } else {
        ContainsFalse:
        return false;
    }
}