# Synchronization Modeling

## Team Members

- tfrank4
- gsingh32
- jeblack

## Video Demo

https://drive.google.com/file/d/1iv35pSwRaaoSf1YfOqMlVUkkMCDiVLEA/view?usp=sharing

## Project Overview

This project uses Temporal Forge to explore different algorithms that synchronize a data structure to work with multiple threads. We specifically chose linked list-sets, i.e. an underlying linked list structure with a set interface:

- `bool add(Node n)`: Tries to add `n` to the set; returns success/failure.
- `bool remove(Node n)`: Tries to remove `n` from the set; returns success/failure.
- `bool contains(Node n)`: True if `n` is a member of the set, else false.

The algorithms come from _The Art of Multiprocessor Synchronization_, the textbook for cs1760. By synchronization, we mean that the set operations can be _linearized_ for any multi-threaded execuation. That means that each method call appears to "take effect" at a particular moment in time, visible to all threads simultaneously. For example, if thread A adds a node and thread B checks that node exists, any other threads should also find the node exists if they check later.

You can get a feel for the problems that arise when multiple threads access an un-synchronized data structure by running the [Unsynchronized Model](/unsynchronized.frg) and inspecting the traces. Then run the [Coarse-Grained Locking Model](/coarse-grained-locking.frg) and [Fine-Grained Locking Model](/fine-grained-locking.frg) to see the difference in the traces.

## Model and Visualization Details

Each trace represents one or more threads stepping through a single method of the algorithm (either `add`, `remove`, or `contains`). When a thread completes the method, it does nothing. When you run a trace of each algorithm, you will see a difference in the order of execution of these algorithmic steps. The Unsynchronized Model will show free interleaving of threads, and the Fine-Grained Locking Model will show more limited interleaving, while the Coarse-Grained Locking Model will show no interleaving.

Each thread is represented as a `sig`, containing its instruction pointer `ip`, local variables, and method arguments. The method run by a thread and the return value are represented by the final state of the instruction pointer: `AddFalse`, `RemoveTrue`, etc. List nodes are also represented as a `sig`, with a single variable field representing the links between nodes.

We did not create a custom visualization; Table View is the easiest to look at. Pay attention to the `ip` field updating between timesteps, as well as associated changes in the `next` field of list nodes.

## Property Tests

We aimed to verify that the synchronization algorithms have a couple properties:

**Correctness:** The data structure behaves as expected in a multi-threaded environment. This means checking that the data structure remains in a valid state:

- nodes in the list are always in order by key
- the tail is always reachable by the head
- deadlock free, i.e eventually all threads will complete their operations and be at the end of the algorithm

...and also that the data structure is linearizable. We tested linearizability with a few specific scenarios which are not exhaustive. All the tests succeed for the coarse-grained and fine-grained locking algorithms, which are supposed to be correct, but some of them fail for the unsynchronized algorithm, as expected.

**Starvation:** We wanted to test that neither of the algorithms involving locks were starvation-free; a thread can repeatedly be overtaken by other threads in acquiring locks. Our model, which only allowed each thread to complete one method per trace, was unable to represent this situation. The model could be extended to represent starvation by allowing threads to restart methods, although this complicates testing logic and requires long trace lengths.

## Model Limitations

We were originally going to include caching in our model. Each thread would have a local cache of the shared heap (in this case, the list nodes' `next` pointers), and reads and writes would not immediately show up on other caches. This design would have captured more of the problems that can occur with multi-processor execution, such as data structure invariants breaking in the unsychronized model. However, we realized this would be too complex to implement in the time frame we had.

## Stakeholders

- People in Academia: Academics involved in concurrent programming who can use this model to explain certain algorithms to students and use it to show correctness.

- CS1760 students who missed lecture and need to understand these algorithms.

- Industry professionals that work with concurrent systems who might want to understand how certain algorithms behaviors change under different constraints, explore how they can adopt and apply these algorithms for other problems. This also applies to end users, who will use the products created by these professionals.

- Computer engineers who think about which atomic instructions to include in computer hardware

- Programming language developers who are trying to create a memory model for their language and decide on the extent of atomic support

- Open source community members interested in concurrent programming who can provide feedback, and adopt the model for their own curiosity.
