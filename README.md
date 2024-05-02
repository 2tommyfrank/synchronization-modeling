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

## How should we understand an instance of your model and what your visualization shows (whether custom or default)?

A trace is the sequential stepping of one or more threads through the algorithmic steps defined. When you run a trace between the Sequential-Model and the Coarse-Grained Locking Model, you will see a difference in the order of execution of these algorithmic steps. The Sequential-Model will show the interleaving of threads and the Coarse-Grained Locking Model will show the threads executing in a more orderly fashion.
