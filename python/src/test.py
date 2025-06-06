import unittest
from .least_recently_used_cache import LeastRecentlyUsedCache

class LeastRecentlyUsedCacheTest(unittest.TestCase):
    def test_constructor(self):
        """Test cache initialization with valid and invalid capacities."""
        # Test valid capacity
        cache = LeastRecentlyUsedCache(1)
        self.assertEqual(cache.capacity, 1)
        
        # Test invalid capacity
        with self.assertRaises(ValueError):
            LeastRecentlyUsedCache(0)
        with self.assertRaises(ValueError):
            LeastRecentlyUsedCache(-1)
    
    def test_put_and_get(self):
        """Test basic put and get operations."""
        cache = LeastRecentlyUsedCache(2)
        
        # Test basic put and get
        cache.put("key1", "value1")
        self.assertEqual(cache.get("key1"), "value1")
        
        # Test updating existing key
        cache.put("key1", "new_value")
        self.assertEqual(cache.get("key1"), "new_value")
        
        # Test getting non-existent key
        self.assertIsNone(cache.get("nonexistent"))
    
    def test_lru_behavior(self):
        """Test that least recently used items are evicted when capacity is reached."""
        cache = LeastRecentlyUsedCache(2)
        
        # Fill cache to capacity
        cache.put("key1", "value1")
        cache.put("key2", "value2")
        
        # Verify both items are present
        self.assertEqual(cache.get("key1"), "value1")
        self.assertEqual(cache.get("key2"), "value2")
        
        # Add third item, should evict key1 (least recently used)
        cache.put("key3", "value3")
        
        # Verify key1 is evicted
        self.assertIsNone(cache.get("key1"))
        self.assertEqual(cache.get("key2"), "value2")
        self.assertEqual(cache.get("key3"), "value3")
        
        # Access key2, then add key4 - should evict key3
        cache.get("key2")
        cache.put("key4", "value4")
        
        # Verify key3 is evicted (key2 was accessed more recently)
        self.assertIsNone(cache.get("key3"))
        self.assertEqual(cache.get("key2"), "value2")
        self.assertEqual(cache.get("key4"), "value4")
    
    def test_access_order(self):
        """Test that accessing items updates their position in the LRU order."""
        cache = LeastRecentlyUsedCache(3)
        
        # Add three items
        cache.put("key1", "value1")
        cache.put("key2", "value2")
        cache.put("key3", "value3")
        
        # Access key1, making it most recently used
        cache.get("key1")
        
        # Add key4, should evict key2 (least recently used)
        cache.put("key4", "value4")
        
        # Verify key2 is evicted, others remain
        self.assertIsNone(cache.get("key2"))
        self.assertEqual(cache.get("key1"), "value1")
        self.assertEqual(cache.get("key3"), "value3")
        self.assertEqual(cache.get("key4"), "value4")
    
    def test_update_existing_key(self):
        """Test that updating an existing key makes it most recently used."""
        cache = LeastRecentlyUsedCache(2)
        
        # Add two items
        cache.put("key1", "value1")
        cache.put("key2", "value2")
        
        # Update key1, making it most recently used
        cache.put("key1", "new_value")
        
        # Add key3, should evict key2 (least recently used)
        cache.put("key3", "value3")
        
        # Verify key2 is evicted, key1 remains with new value
        self.assertIsNone(cache.get("key2"))
        self.assertEqual(cache.get("key1"), "new_value")
        self.assertEqual(cache.get("key3"), "value3")

if __name__ == '__main__':
    unittest.main()
