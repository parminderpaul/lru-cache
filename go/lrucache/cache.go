package lrucache

import "errors"

// ErrInvalidCapacity is returned when trying to create a cache with capacity <= 0
var ErrInvalidCapacity = errors.New("capacity must be positive")

// Cache implements an LRU (Least Recently Used) cache
type Cache struct {
	capacity int
	cache    map[string]*CacheItem // key -> CacheItem mapping
	head     *CacheItem           // Most recently used
	tail     *CacheItem           // Least recently used
}

// Capacity returns the maximum number of items the cache can hold
func (c *Cache) Capacity() int {
	return c.capacity
}

// New creates a new LRU Cache with the specified capacity
func NewCache(capacity int) (*Cache, error) {
	if capacity <= 0 {
		return nil, ErrInvalidCapacity
	}

	c := &Cache{
		capacity: capacity,
		cache:    make(map[string]*CacheItem),
	}

	// Initialize dummy head and tail nodes - these are used to simplify list manipulation
	c.head = NewCacheItem("", nil)
	c.tail = NewCacheItem("", nil)
	c.head.next = c.tail
	c.tail.prev = c.head

	return c, nil
}

// removeNode removes a node from its current position in the list
func (c *Cache) removeNode(item *CacheItem) {
	item.prev.next = item.next
	item.next.prev = item.prev
}

// addToHead adds a node to the head of the list (most recently used)
func (c *Cache) addToHead(item *CacheItem) {
	item.next = c.head.next
	item.prev = c.head
	c.head.next.prev = item
	c.head.next = item
}

// moveToHead moves an existing node to the head of the list
func (c *Cache) moveToHead(item *CacheItem) {
	c.removeNode(item)
	c.addToHead(item)
}

// Get retrieves an item from the cache by key
func (c *Cache) Get(key string) (interface{}, bool) {
	if item, exists := c.cache[key]; exists {
		c.moveToHead(item)
		return item.value, true
	}
	return nil, false
}

// Put adds or updates an item in the cache
func (c *Cache) Put(key string, value interface{}) {
	if item, exists := c.cache[key]; exists {
		// Update existing node
		item.value = value
		c.moveToHead(item)
		return
	}

	// Create new node
	item := NewCacheItem(key, value)
	c.cache[key] = item
	c.addToHead(item)

	// Remove least recently used if at capacity
	if len(c.cache) > c.capacity {
		lruItem := c.tail.prev
		c.removeNode(lruItem)
		delete(c.cache, lruItem.key)
	}
}
