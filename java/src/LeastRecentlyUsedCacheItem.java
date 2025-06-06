/**
 * Represents a single item in the LRU cache, stored as a node in a doubly-linked list.
 * Each item contains a key, value, and references to the next and previous items in the list.
 */
public class LeastRecentlyUsedCacheItem {
	private final String key;
	private final Object value;
	private LeastRecentlyUsedCacheItem next;
	private LeastRecentlyUsedCacheItem prev;

	public LeastRecentlyUsedCacheItem(String key, Object value) {
		this.key = key;
		this.value = value;
	}

	public LeastRecentlyUsedCacheItem(String key, Object value, LeastRecentlyUsedCacheItem next, LeastRecentlyUsedCacheItem prev) {
		this.key = key;
		this.value = value;
		this.next = next;
		this.prev = prev;
	}

	// Getters and setters
	public String getKey() {
		return key;
	}

	public Object getValue() {
		return value;
	}

	public LeastRecentlyUsedCacheItem getNext() {
		return next;
	}

	public void setNext(LeastRecentlyUsedCacheItem next) {
		this.next = next;
	}

	public LeastRecentlyUsedCacheItem getPrev() {
		return prev;
	}

	public void setPrev(LeastRecentlyUsedCacheItem prev) {
		this.prev = prev;
	}
} 