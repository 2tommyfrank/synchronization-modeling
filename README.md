# Synchronization Modeling

## Team Members

- tfrank4
- gsingh32
- jeblack

## Demo - Video

https://drive.google.com/file/d/1iv35pSwRaaoSf1YfOqMlVUkkMCDiVLEA/view?usp=sharing

## Project Overview

This project explores different _`synchronization`_ algorithms applied to a data structure (singly linked list) that provides a _`set`_ like interface.

- `add(Node n)`: Adds $n$ to the _`set`_.
- `remove(Node n)`: Removes $n$ from the _`set`_.
- `contains(Node n)`: True if $n$ exists in the _`set`_, else false.

This data structure is being operated on by multiple threads concurrently. Synchronization, means that the _`set`_ and its operations behave as expected in a multi-threaded environment (**this could be better defined**). You can get a feel for the problems that arise when multiple threads access an un-synchronized data structure by running the [Sequential-Model](/sequential.frg) and inspecting the traces. Then run the [Coarse-Grained Locking Model](/coarse-grained-locking.frg) and see the difference in the traces.

We look to verify that the synchronization algorithms implemented have a couple properties:

### Properties Tests:
**correctness**: The data structure behaves as expected in a multi-threaded environment.
- nodes in the list are always in order by key
- the tail is always reachable by the head
- deadlock free, i.e eventually all threads will complete their operations and be at the end of the algorithm
- 
### Model Tests:

- He owner of the lock should remian hte same thorughout the critical section

## What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?

## What assumptions did you make about scope?

## What are the limits of your model?

- We wanted to be able to verify/non-verify that the algorithms we run are starvation free. There current mplementation of our algorithm does not allow us to verify this property. We would need to allows threads that have completed their operations to be able to re-enter the algorithm. This would require a more complex model that we did not have time to implement.

## Did your goals change at all from your proposal?

## Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?

We were originally going to include the idea of individual core caches into our model. This would have captured some problems that can occur with cache coherence when running in a multi-core environment. However, we realized that this would be too complex to implement in the time frame we had.

## How should we understand an instance of your model and what your visualization shows (whether custom or default)?

A trace is the sequential stepping of one or more threads through the algorithmic steps defined for each function (add, remove, contains). When you run a trace between the Sequential-Model and the Coarse-Grained Locking Model, you will see a difference in the order of execution of these algorithmic steps. The Sequential-Model will show the interleaving of threads and the Coarse-Grained Locking Model will show the threads executing in a more defined thread safe manner.

## Stakeholders

- People in Academia: Academics involved in concurrent programming who can use this model to explain certain algorithms to students and use it to show correctness.

- CS1760 students who missed lecture and need to understand these algorithms.

- Industry professionals that work with concurrent systems who might want to understand how certain algorithms behaviors change under different constraints, explore how they can adopt and apply these algorithms for other problems. This also applies to end users, who will use the products created by these professionals.

- Computer engineers who think about which atomic instructions to include in computer hardware

- Programming language developers who are trying to create a memory model for their language and decide on the extent of atomic support

- Open source community members interested in concurrent programming who can provide feedback, and adopt the model for their own curiosity.
