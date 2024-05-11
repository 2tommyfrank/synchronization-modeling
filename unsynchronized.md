This file helps breakdown the functions that implement the *`set`* interface into logical chunks. The labels such as `Init`, `AddCheck`, ..., etc are used to help identify the different steps (chunks) of the algorithm. Threads will progress through these steps within a trace of our model. Notice how there is no locking in this model. This is the sequential model.

## `boolean add(Node n)`: Adds $n$ to the *`set`*

```python
boolean add(Node node) 
{
    Init:
        prev = head;
        curr = head.next;

    TraversalCheck:
        while (curr.key < node.key) 
        {
            Traversal:
                prev = curr;
                curr = curr.next;
        }

    AddCheck:
        if (curr.key == node.key) 
        {
            AddFalse:
                return false;
        } 
        else
        {
            Add1:
                node.next = curr;

            Add2:
                prev.next = node;

            AddTrue:                
                return true;
        }
}
```

## `boolean remove(Node n)`: Removes $n$ from the *`set`*

```python
boolean remove(Node node) 
{
    Init:
        prev = head;
        curr = head.next;

    TraversalCheck:     
        while (curr.key < node.key) 
        {
            Traversal:
                prev = curr;
                curr = curr.next;
        }
    RemoveCheck:
        if (curr.key == node.key) 
        {
            Remove:                 
                prev.next = curr.next;

            RemoveTrue:             
                return true;
        } 
        else 
        {
            RemoveFalse:            
                return false;
        }
}
```

## `boolean contains(Node n)`: True if $n$ exists in the *`set`*, else false.

```python
boolean contains(Node node) 
{
    Init:               
        prev = head;
        curr = head.next;

    TraversalCheck:     
        while (curr.key < node.key) 
        {
            Traversal:              
                prev = curr;
                curr = curr.next;
        }

    Contains:
        if (curr.key == node.key) 
        {
            ContainsTrue:           
                return true;
        } 
        else 
        {
            ContainsFalse:          
                return false;
        }
}
```
