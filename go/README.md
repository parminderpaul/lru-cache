# OOP LRU Cache in Go

This directory contains a Go implementation of the LRU Cache project specified in the parent
directory's `README.md`. To run the tests, use `go test ./tests/...`.

## Requirements

- Go (tested with 1.18.1)

## Usage

```go
package main

import (
	"fmt"
	"github.com/Dan-Q/lru-cache/go/lrucache"
)

func main() {
	// Create a cache with capacity of 3
	cache, err := lrucache.NewCache(3)
	if err != nil {
		panic(err)
	}

	// Add items to the cache
	cache.Put("key1", "value1")
	cache.Put("key2", "value2")
	cache.Put("key3", "value3")

	// Retrieve items
	if value, exists := cache.Get("key1"); exists {
		fmt.Println(value) // Prints: value1
	}

	// Adding a new item when cache is full removes the least recently used item
	cache.Put("key4", "value4") // Removes "key2" because this was least recently used

	// Updating an existing key makes it most recently used
	cache.Put("key3", "new_value3") // Updates value and makes key3 most recently used
}
```

## Notes

This implementation follows Go's (opinionated!) idioms while maintaining the same functionality
as the other language implementations:

1. Uses Go's struct types and methods instead of classes
2. Returns errors explicitly rather than throwing exceptions
3. Uses Go's built-in `map` type for the hashmap implementation
4. Uses Go's testing package for unit tests
5. Uses Go's interface{} type for values to allow storing any type (similar to Python's Any)
