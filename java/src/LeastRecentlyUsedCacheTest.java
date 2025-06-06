import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class LeastRecentlyUsedCacheTest {
	
	@Test
	public void testConstructor() {
		// Test valid capacity
		LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(5);
		assertNotNull(cache);

		// Test invalid capacity
		assertThrows(IllegalArgumentException.class, () -> {
			new LeastRecentlyUsedCache(0);
		}, "Should have thrown IllegalArgumentException for capacity 0");

		assertThrows(IllegalArgumentException.class, () -> {
			new LeastRecentlyUsedCache(-1);
		}, "Should have thrown IllegalArgumentException for negative capacity");
	}

	@Test
	public void testPutAndGet() {
		LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(3);

		// Test basic put and get
		cache.put("key1", "value1");
		assertEquals("value1", cache.get("key1"));

		// Test updating existing key
		cache.put("key1", "newValue1");
		assertEquals("newValue1", cache.get("key1"));

		// Test getting non-existent key
		assertThrows(IllegalArgumentException.class, () -> {
			cache.get("nonexistent");
		}, "Should have thrown IllegalArgumentException for non-existent key");
	}

	@Test
	public void testLRUBehavior() {
		LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(3);

		// Fill the cache
		cache.put("key1", "value1");
		cache.put("key2", "value2");
		cache.put("key3", "value3");

		// Verify all items are present
		assertEquals("value1", cache.get("key1"));
		assertEquals("value2", cache.get("key2"));
		assertEquals("value3", cache.get("key3"));

		// Add one more item, should remove key1 (least recently used)
		cache.put("key4", "value4");
		assertThrows(IllegalArgumentException.class, () -> {
			cache.get("key1");
		}, "key1 should have been removed");

		// Verify other items are still present
		assertEquals("value2", cache.get("key2"));
		assertEquals("value3", cache.get("key3"));
		assertEquals("value4", cache.get("key4"));
	}

	@Test
	public void testAccessOrder() {
		LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(3);

		// Fill the cache
		cache.put("key1", "value1");
		cache.put("key2", "value2");
		cache.put("key3", "value3");

		// Access key1, making key2 the least recently used
		cache.get("key1");

		// Add new item, should remove key2
		cache.put("key4", "value4");
		assertThrows(IllegalArgumentException.class, () -> {
			cache.get("key2");
		}, "key2 should have been removed");

		// Verify remaining items
		assertEquals("value1", cache.get("key1"));
		assertEquals("value3", cache.get("key3"));
		assertEquals("value4", cache.get("key4"));
	}

	@Test
	public void testUpdateExistingKey() {
		LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(2);

		// Add two items
		cache.put("key1", "value1");
		cache.put("key2", "value2");

		// Update key1, making key2 the least recently used
		cache.put("key1", "newValue1");

		// Add new item, should remove key2
		cache.put("key3", "value3");
		assertThrows(IllegalArgumentException.class, () -> {
			cache.get("key2");
		}, "key2 should have been removed");

		// Verify remaining items
		assertEquals("newValue1", cache.get("key1"));
		assertEquals("value3", cache.get("key3"));
	}
} 