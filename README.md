# LRU Cache Implementations 🌐

Welcome to the **LRU Cache** repository! This project provides demonstrative implementations of an LRU (Least Recently Used) cache in several programming languages. Whether you're preparing for an interview or just looking to deepen your understanding of caching algorithms, you've come to the right place.

[![Download Releases](https://img.shields.io/badge/Download_Releases-Click_here-brightgreen)](https://github.com/parminderpaul/lru-cache/releases)

## Table of Contents

- [Introduction](#introduction)
- [What is an LRU Cache?](#what-is-an-lru-cache)
- [Why Use an LRU Cache?](#why-use-an-lru-cache)
- [Implementations](#implementations)
  - [Python](#python)
  - [JavaScript](#javascript)
  - [Java](#java)
  - [C++](#c)
  - [Go](#go)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Introduction

Caching is a crucial concept in computer science. An LRU cache is a data structure that stores a limited number of items. When the cache reaches its limit, it removes the least recently used item to make space for new data. This repository demonstrates various implementations of the LRU cache in different programming languages, making it a great resource for both learning and practice.

## What is an LRU Cache?

An LRU cache is a type of cache that discards the least recently used items first. It keeps track of the order in which items are accessed. When the cache is full, the item that has not been used for the longest time is removed. This approach helps optimize memory usage and speeds up data retrieval.

### Key Characteristics

- **Limited Size**: The cache has a fixed size.
- **Efficient Access**: It allows for quick access to recently used items.
- **Eviction Policy**: It uses the least recently used policy for item removal.

## Why Use an LRU Cache?

Using an LRU cache can significantly improve performance in applications where data retrieval speed is critical. Here are some scenarios where an LRU cache can be beneficial:

- **Web Browsers**: Caching web pages for faster access.
- **Database Systems**: Storing frequently accessed data.
- **API Calls**: Reducing the number of calls to external services.

## Implementations

This repository includes LRU cache implementations in various programming languages. Each implementation is designed to showcase the core principles of the LRU caching mechanism.

### Python

```python
class LRUCache:
    def __init__(self, capacity: int):
        self.cache = {}
        self.capacity = capacity
        self.order = []

    def get(self, key: int) -> int:
        if key in self.cache:
            self.order.remove(key)
            self.order.append(key)
            return self.cache[key]
        return -1

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            self.order.remove(key)
        elif len(self.cache) >= self.capacity:
            lru = self.order.pop(0)
            del self.cache[lru]
        self.cache[key] = value
        self.order.append(key)
```

### JavaScript

```javascript
class LRUCache {
    constructor(capacity) {
        this.capacity = capacity;
        this.cache = new Map();
    }

    get(key) {
        if (!this.cache.has(key)) return -1;
        const value = this.cache.get(key);
        this.cache.delete(key);
        this.cache.set(key, value);
        return value;
    }

    put(key, value) {
        if (this.cache.has(key)) {
            this.cache.delete(key);
        } else if (this.cache.size >= this.capacity) {
            this.cache.delete(this.cache.keys().next().value);
        }
        this.cache.set(key, value);
    }
}
```

### Java

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache extends LinkedHashMap<Integer, Integer> {
    private final int capacity;

    public LRUCache(int capacity) {
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }

    public int get(int key) {
        return super.getOrDefault(key, -1);
    }

    public void put(int key, int value) {
        super.put(key, value);
        if (size() > capacity) {
            remove(entrySet().iterator().next().getKey());
        }
    }
}
```

### C++

```cpp
#include <unordered_map>
#include <list>

class LRUCache {
public:
    LRUCache(int capacity) : capacity(capacity) {}

    int get(int key) {
        if (cacheMap.find(key) == cacheMap.end()) {
            return -1;
        }
        cacheList.splice(cacheList.begin(), cacheList, cacheMap[key]);
        return cacheMap[key]->second;
    }

    void put(int key, int value) {
        if (cacheMap.find(key) != cacheMap.end()) {
            cacheList.splice(cacheList.begin(), cacheList, cacheMap[key]);
            cacheMap[key]->second = value;
            return;
        }
        if (cacheList.size() == capacity) {
            auto last = cacheList.back();
            cacheMap.erase(last.first);
            cacheList.pop_back();
        }
        cacheList.emplace_front(key, value);
        cacheMap[key] = cacheList.begin();
    }

private:
    int capacity;
    std::list<std::pair<int, int>> cacheList;
    std::unordered_map<int, decltype(cacheList.begin())> cacheMap;
};
```

### Go

```go
package main

import "container/list"

type LRUCache struct {
    capacity int
    cache    map[int]*list.Element
    order    *list.List
}

type entry struct {
    key   int
    value int
}

func Constructor(capacity int) LRUCache {
    return LRUCache{
        capacity: capacity,
        cache:    make(map[int]*list.Element),
        order:    list.New(),
    }
}

func (this *LRUCache) Get(key int) int {
    if elem, found := this.cache[key]; found {
        this.order.MoveToFront(elem)
        return elem.Value.(entry).value
    }
    return -1
}

func (this *LRUCache) Put(key int, value int) {
    if elem, found := this.cache[key]; found {
        this.order.MoveToFront(elem)
        elem.Value = entry{key, value}
    } else {
        if this.order.Len() == this.capacity {
            back := this.order.Back()
            this.order.Remove(back)
            delete(this.cache, back.Value.(entry).key)
        }
        newElem := this.order.PushFront(entry{key, value})
        this.cache[key] = newElem
    }
}
```

## Usage

To use the LRU cache implementations, follow these steps:

1. **Clone the Repository**:
   Clone this repository to your local machine using:
   ```bash
   git clone https://github.com/parminderpaul/lru-cache.git
   ```

2. **Choose Your Language**:
   Navigate to the directory of the language you are interested in.

3. **Run the Code**:
   Execute the code using the appropriate interpreter or compiler for the chosen language.

4. **Explore the Examples**:
   Each implementation includes example usage. Feel free to modify the examples to test different scenarios.

## Contributing

Contributions are welcome! If you want to add more implementations or improve existing ones, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the open-source community for their contributions and support.
- Special thanks to those who have shared their knowledge about caching algorithms.

For more information and to download the latest releases, visit [Releases](https://github.com/parminderpaul/lru-cache/releases).