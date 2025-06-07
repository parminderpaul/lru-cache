# OOP LRU Cache in TypeScript

This directory contains a TypeScript implementation of the LRU Cache project specified in the parent
directory's `README.md`. To test it, run `npm install && npm test`.

## Requirements

- Node.js (tested with v20)
- npm

## Usage

The cache is implemented as a generic class, allowing you to cache any type of value. Here's how to use it:

```typescript
import { LeastRecentlyUsedCache } from './src/LeastRecentlyUsedCache';

// Create a new (string) cache with capacity of 3
const cache = new LeastRecentlyUsedCache<string>(3);

// Add some items to the cache
cache.put('key1', 'value1');
cache.put('key2', 'value2');
cache.put('key3', 'value3');

// Retrive items
console.log(cache.get('key1')); // Returns 'value1'

// Adding a new item when cache is full removes the least recently used item
cache.put('key4', 'value4'); // Removes 'key2' because this was least recently used

// Updating an existing key makes it most recently used
cache.put('key3', 'new_value3');  // Updates value and makes key3 most recently used
```

# Notes

Most other implementations in this project use either a generic object (for loosely-typed languages
PHP, Python, and Ruby) or else an interface (in not-really-OOP Go) to represent the stored item.
However, this implementation (and Java's) uses Generics.

This means that you'll want to specify the type of object that you'll be caching upon
instantiation, although this can be a generic superclass (e.g. `<object>`) or specific complex
object, e.g.:

```typescript
interface Page {
  slug: string;
  title: string;
  content: string;
}

const pageCache = new LeastRecentlyUsedCache<Page>(100);
```
