# OOP LRU Cache in Several Languages

An object-oriented implementation of an Least-Recently Used (LRU) Cache in several different
programming languages, using a hashmap + doubly-linked-list structure to facilitate O(1) `get` and
`put` operations.

## Background

To keep my hand in at a selection of different object-oriented programming languages, some of which
I haven't used as recently as others, I decided to implement a variant of a classic "tech test"
problem in each of them. The specification is as follows:

> In an object-oriented manner, implement an LRU (Least-Recently Used) cache. Upon instantiation,
> the size of the cache is specified. Arbitrary objects can be `put` into the cache, along with a
> retrieval key in the form of a string. Using the same string, you can `get` the objects back.
> If a `put` operation would increase the number of objects in the cache beyond the size specified
> at instantiation, the cached object that was least-recently accessed (that is, by either a `put`
> or `get` operation) is removed to make room for it. `put`ting a duplicate key into the cache
> should not add a second copy, but should make the referenced object the most-recently-accessed.
> Both the `get` and `put` operations should resolve within constant (O(1)) time.

## Understand

### Simple case with O(n) complexity

A simple LRU cache is functionally a (LIFO) queue and can be implemented as a linked-list. When a
new item is `put` into the cache, it's pushed into the head of the queue, and the tail item is
discarded if the queue would become too long. For `get` retrieval, we could iterate through the
queue until we find the matching item and return it, if present, as well as moving it up to the
head of the queue.

However, this does not meet the brief because both `put` and `get` exhibit up-to O(n) complexity,
because both operations require a full iteration through the collection as well as potentially
re-arranging the queue by hoisting a new item to its head. To get O(1) complexity, we need a more
sophisticated implementation...

### Achieving O(1) complexity

An LRU cache can achieve O(1) complexity with two modifications to the above:

1. Use of a hashmap to connect the cache keys to the items in the cache, and
2. Use of a doubly-linked-list as the underlying data structure, which allows for re-arrangement
   of the queue in linear time.

Under this model:

- `get` uses the hashmap to see if an item exists; if it does, it connects its neighbours to one
  another to remove itself from the list and then inserts itself at the head, informing its new
  neighbour; then it returns the item.
- `put` uses the hashmap to see if the key already exists (and if so, treats it like `get`); if
  not, it inserts itself as the head item, links from the hashmap, and informs its neighbour. It
  also checks the size of the cache and if it would become too-large, points the tail at its
  predecessor and unlinks it from that predecessor.

Both of these operations only need to touch the hashmap and the part of the doubly-linked list
that impacts them (e.g. connecting their former neighbours to one another when moved elsewhere).

## Implementations

Each directory within this repository contains a solution in a different programming language. See
the `README.md` file within each directory for usage instructions.

Languages represented are:

- Java
- PHP
- Python
- Ruby
