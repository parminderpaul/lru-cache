package lrucache

// CacheItem represents an item in the doubly-linked list
type CacheItem struct {
	key   string
	value interface{}
	prev  *CacheItem
	next  *CacheItem
}

// NewCacheItem creates a new cache item with the given key and value
func NewCacheItem(key string, value interface{}) *CacheItem {
	return &CacheItem{
		key:   key,
		value: value,
	}
}
