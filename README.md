# Synchronization Modeling

## Team Members

- tfrank4
- gsingh32
- jeblack

## Project Overview

 This project explores different *`synchronization`* algorithms applied to a data structure (singly linked list) that provides a *`set`* like interface.

- `add(Node n)`: Adds $n$ to the *`set`*.
- `remove(Node n)`: Removes $n$ from the *`set`*.
- `contains(Node n)`: True if $n$ exists in the *`set`*, else false.

This data structure is being operated on by multiple threads concurrently. Synchronization, means that the *`set`* and its operations behave as expected in a multi-threaded environment (**this could be better defined**). You can get a feel for the problems that arise when multiple threads access an un-synchronized data structure by running the [Sequential-Model](/sequential.frg) and inspecting the traces. Then run the [Coarse-Grained Locking Model](/coarse-grained-locking.frg) and see the difference in the traces.

We look to verify that the synchronization algorithms implemented have a couple properties:

- **Starvation Free**: No thread is left waiting indefinitely.
- **Deadlock Free**: Some thread will make progress.
- **NEED TO ADD MORE PROPERTIES**

## What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?

## What assumptions did you make about scope?

## What are the limits of your model?

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