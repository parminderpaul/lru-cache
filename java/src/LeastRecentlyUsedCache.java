import java.util.HashMap;
import java.util.Map;

/**
 * Implementation of a Least Recently Used (LRU) cache using a HashMap for O(1) lookups
 * and a doubly-linked list for maintaining the order of items by their usage.
 */
public class LeastRecentlyUsedCache {
	private final int capacity;
	private final Map<String, LeastRecentlyUsedCacheItem> cache;
	private LeastRecentlyUsedCacheItem head;  // Most recently used
	private LeastRecentlyUsedCacheItem tail;  // Least recently used

	/**
	 * Creates a new LRU cache with the specified capacity.
	 * @param capacity The maximum number of items the cache can hold
	 * @throws IllegalArgumentException if capacity is less than 1
	 */
	public LeastRecentlyUsedCache(int capacity) {
		if (capacity < 1) {
			throw new IllegalArgumentException("Cache capacity must be at least 1");
		}
		this.capacity = capacity;
		this.cache = new HashMap<>();
	}

	/**
	 * Adds or updates a value in the cache. If the key already exists, its value is updated
	 * and it becomes the most recently used item. If the cache is full, the least recently
	 * used item is removed before adding the new item.
	 * @param key The key to store the value under
	 * @param value The value to store
	 */
	public void put(String key, Object value) {
		// If key exists, update it and move to front
		if (cache.containsKey(key)) {
			LeastRecentlyUsedCacheItem oldItem = cache.get(key);
			removeFromList(oldItem);  // Remove the old item from the list
			LeastRecentlyUsedCacheItem newItem = new LeastRecentlyUsedCacheItem(key, value);
			addToFront(newItem);
			cache.put(key, newItem);
			return;
		}

		// If cache is full, remove least recently used item
		if (cache.size() >= capacity) {
			removeLeastRecentlyUsed();
		}

		// Add new item
		LeastRecentlyUsedCacheItem newItem = new LeastRecentlyUsedCacheItem(key, value);
		addToFront(newItem);
		cache.put(key, newItem);
	}

	/**
	 * Retrieves a value from the cache. If the key exists, the item becomes the most
	 * recently used item. If the key doesn't exist, throws an exception.
	 * @param key The key to look up
	 * @return The value associated with the key
	 * @throws IllegalArgumentException if the key is not found in the cache
	 */
	public Object get(String key) {
		LeastRecentlyUsedCacheItem item = cache.get(key);
		if (item == null) {
			throw new IllegalArgumentException("Key not found in cache: " + key);
		}

		// Move to front of list (most recently used)
		removeFromList(item);
		addToFront(item);
		return item.getValue();
	}

	// Private helper methods

	private void removeLeastRecentlyUsed() {
		if (tail != null) {
			cache.remove(tail.getKey());
			removeFromList(tail);
		}
	}

	private void removeFromList(LeastRecentlyUsedCacheItem item) {
		if (item == null) return;

		// Update prev item's next pointer
		if (item.getPrev() != null) {
			item.getPrev().setNext(item.getNext());
		} else {
			// This was the head
			head = item.getNext();
		}

		// Update next item's prev pointer
		if (item.getNext() != null) {
			item.getNext().setPrev(item.getPrev());
		} else {
			// This was the tail
			tail = item.getPrev();
		}

		// Clear the item's pointers
		item.setNext(null);
		item.setPrev(null);
	}

	private void addToFront(LeastRecentlyUsedCacheItem item) {
		if (head == null) {
			// First item in the list
			head = item;
			tail = item;
		} else {
			// Add to front of list
			item.setNext(head);
			head.setPrev(item);
			head = item;
		}
	}
} 