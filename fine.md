This file helps breakdown the functions that implement the *`set`* interface into logical chunks. The labels such as `Init`, `Locked`, `AddCheck`, ..., etc are used to help identify the different steps (chunks) of the algorithm. Threads will progress through these steps within a trace of our model. Notice here we lock the entire data structure before performing any operation. This is the fine-grained locking strategy.

## `boolean add(Node n)`: Adds $n$ to the *`set`*

```python
boolean add(Node node) 
{
  Init:
    prev = head;
    prev.lock();

  HeadLocked:
    curr = head.next;
    curr.lock();

  TraversalCheck:
    while (curr.key < node.key) 
    {
      Traversal1:
        prev.unlock();
      
      Traversal2:
        prev = curr;
        curr = curr.next;
        curr.lock();
    }

  AddCheck:
    if (curr.key == node.key) 
    {
        prev.unlock();
        curr.unlock();

      AddFalse:
        return false;
    } 
    else
    {
      Add1:
        node.next = curr;

      Add2:
        prev.next = node;
        prev.unlock();
        curr.unlock();

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
    prev.lock();

  HeadLocked:
    curr = head.next;
    curr.lock();

  TraversalCheck:
    while (curr.key < node.key) 
    {
      Traversal1:
        prev.unlock();
      
      Traversal2:
        prev = curr;
        curr = curr.next;
        curr.lock();
    }

  RemoveCheck:
    if (curr.key == node.key) 
    {
      Remove:         
        prev.next = curr.next;
        prev.unlock();
        curr.unlock();

      RemoveTrue:       
        return true;
    } 
    else 
    {
        prev.unlock();
        curr.unlock();

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
    prev.lock();

  HeadLocked:
    curr = head.next;
    curr.lock();

  TraversalCheck:
    while (curr.key < node.key) 
    {
      Traversal1:
        prev.unlock();
      
      Traversal2:
        prev = curr;
        curr = curr.next;
        curr.lock();
    }

  Contains:
    if (curr.key == node.key) 
    {
        prev.unlock();
        curr.unlock();

      ContainsTrue:       
        return true;
    } 
    else 
    {
        prev.unlock();
        curr.unlock();

      ContainsFalse:      
        return false;
    }
}
```
