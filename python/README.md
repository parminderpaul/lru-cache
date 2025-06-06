# OOP LRU Cache in Python

This directory contains a Python 3 implementation of the LRU Cache project specified in the parent
directory's `README.md`. To test it, run e.g. `python3 -m unittest -v src/test.py`.

## Requirements

- Python 3.6+

## Usage

```python
from src.least_recently_used_cache import LeastRecentlyUsedCache

# Create a cache with capacity of 3
cache = LeastRecentlyUsedCache(3)

# Add items to the cache
cache.put("key1", "value1")
cache.put("key2", "value2")
cache.put("key3", "value3")

# Retrieve items
value = cache.get("key1")  # Returns "value1"

# Adding a new item when cache is full removes the least recently used item
cache.put("key4", "value4")  # Removes "key2" because this was least recently used

# Updating an existing key makes it most recently used
cache.put('key3', 'new_value3')  # Updates value and makes key3 most recently used
```

## Notes

My understanding is that a Python `dict` is the optimal tool to use as a hashmap.
