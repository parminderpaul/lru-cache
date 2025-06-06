package tests

import (
	"testing"
	"github.com/Dan-Q/lru-cache/go/lrucache"
)

func TestNew(t *testing.T) {
	// Test valid capacity
	cache, err := lrucache.NewCache(1)
	if err != nil {
		t.Errorf("New(1) returned error: %v", err)
	}
	if cache == nil {
		t.Error("New(1) returned nil cache")
	}
	if cache.Capacity() != 1 {
		t.Errorf("New(1) capacity = %d; want 1", cache.Capacity())
	}

	// Test invalid capacity
	_, err = lrucache.NewCache(0)
	if err != lrucache.ErrInvalidCapacity {
		t.Errorf("New(0) error = %v; want %v", err, lrucache.ErrInvalidCapacity)
	}

	_, err = lrucache.NewCache(-1)
	if err != lrucache.ErrInvalidCapacity {
		t.Errorf("New(-1) error = %v; want %v", err, lrucache.ErrInvalidCapacity)
	}
}

func TestPutAndGet(t *testing.T) {
	cache, _ := lrucache.NewCache(2)

	// Test basic put and get
	cache.Put("key1", "value1")
	if value, exists := cache.Get("key1"); !exists || value != "value1" {
		t.Errorf("Get(\"key1\") = %v, %v; want \"value1\", true", value, exists)
	}

	// Test updating existing key
	cache.Put("key1", "new_value")
	if value, exists := cache.Get("key1"); !exists || value != "new_value" {
		t.Errorf("Get(\"key1\") after update = %v, %v; want \"new_value\", true", value, exists)
	}

	// Test getting non-existent key
	if value, exists := cache.Get("nonexistent"); exists || value != nil {
		t.Errorf("Get(\"nonexistent\") = %v, %v; want nil, false", value, exists)
	}
}

func TestLRUBehavior(t *testing.T) {
	cache, _ := lrucache.NewCache(2)

	// Fill cache to capacity
	cache.Put("key1", "value1")
	cache.Put("key2", "value2")

	// Verify both items are present
	if value, exists := cache.Get("key1"); !exists || value != "value1" {
		t.Errorf("Get(\"key1\") = %v, %v; want \"value1\", true", value, exists)
	}
	if value, exists := cache.Get("key2"); !exists || value != "value2" {
		t.Errorf("Get(\"key2\") = %v, %v; want \"value2\", true", value, exists)
	}

	// Add third item, should evict key1 (least recently used)
	cache.Put("key3", "value3")

	// Verify key1 is evicted
	if value, exists := cache.Get("key1"); exists || value != nil {
		t.Errorf("Get(\"key1\") after eviction = %v, %v; want nil, false", value, exists)
	}
	if value, exists := cache.Get("key2"); !exists || value != "value2" {
		t.Errorf("Get(\"key2\") = %v, %v; want \"value2\", true", value, exists)
	}
	if value, exists := cache.Get("key3"); !exists || value != "value3" {
		t.Errorf("Get(\"key3\") = %v, %v; want \"value3\", true", value, exists)
	}

	// Access key2, then add key4 - should evict key3
	cache.Get("key2")
	cache.Put("key4", "value4")

	// Verify key3 is evicted (key2 was accessed more recently)
	if value, exists := cache.Get("key3"); exists || value != nil {
		t.Errorf("Get(\"key3\") after eviction = %v, %v; want nil, false", value, exists)
	}
	if value, exists := cache.Get("key2"); !exists || value != "value2" {
		t.Errorf("Get(\"key2\") = %v, %v; want \"value2\", true", value, exists)
	}
	if value, exists := cache.Get("key4"); !exists || value != "value4" {
		t.Errorf("Get(\"key4\") = %v, %v; want \"value4\", true", value, exists)
	}
}

func TestAccessOrder(t *testing.T) {
	cache, _ := lrucache.NewCache(3)

	// Add three items
	cache.Put("key1", "value1")
	cache.Put("key2", "value2")
	cache.Put("key3", "value3")

	// Access key1, making it most recently used
	cache.Get("key1")

	// Add key4, should evict key2 (least recently used)
	cache.Put("key4", "value4")

	// Verify key2 is evicted, others remain
	if value, exists := cache.Get("key2"); exists || value != nil {
		t.Errorf("Get(\"key2\") after eviction = %v, %v; want nil, false", value, exists)
	}
	if value, exists := cache.Get("key1"); !exists || value != "value1" {
		t.Errorf("Get(\"key1\") = %v, %v; want \"value1\", true", value, exists)
	}
	if value, exists := cache.Get("key3"); !exists || value != "value3" {
		t.Errorf("Get(\"key3\") = %v, %v; want \"value3\", true", value, exists)
	}
	if value, exists := cache.Get("key4"); !exists || value != "value4" {
		t.Errorf("Get(\"key4\") = %v, %v; want \"value4\", true", value, exists)
	}
}

func TestUpdateExistingKey(t *testing.T) {
	cache, _ := lrucache.NewCache(2)

	// Add two items
	cache.Put("key1", "value1")
	cache.Put("key2", "value2")

	// Update key1, making it most recently used
	cache.Put("key1", "new_value")

	// Add key3, should evict key2 (least recently used)
	cache.Put("key3", "value3")

	// Verify key2 is evicted, key1 remains with new value
	if value, exists := cache.Get("key2"); exists || value != nil {
		t.Errorf("Get(\"key2\") after eviction = %v, %v; want nil, false", value, exists)
	}
	if value, exists := cache.Get("key1"); !exists || value != "new_value" {
		t.Errorf("Get(\"key1\") = %v, %v; want \"new_value\", true", value, exists)
	}
	if value, exists := cache.Get("key3"); !exists || value != "value3" {
		t.Errorf("Get(\"key3\") = %v, %v; want \"value3\", true", value, exists)
	}
}
