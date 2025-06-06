from typing import Any, Optional
from .least_recently_used_cache_item import LeastRecentlyUsedCacheItem

class LeastRecentlyUsedCache:
    """LRU Cache implementation using a dictionary and doubly-linked list for O(1) operations."""
    
    def __init__(self, capacity: int):
        """Initialize the LRU Cache with a fixed capacity.
        
        Args:
            capacity: Maximum number of items the cache can hold
        """
        if capacity <= 0:
            raise ValueError("Capacity must be positive")
            
        self.capacity = capacity
        self.cache: dict[str, LeastRecentlyUsedCacheItem] = {}  # key -> Item mapping
        
        # Initialize dummy head and tail nodes for easier list manipulation
        self.head = LeastRecentlyUsedCacheItem("", None)  # Most recently used
        self.tail = LeastRecentlyUsedCacheItem("", None)  # Least recently used
        self.head.next = self.tail
        self.tail.prev = self.head
    
    def _remove_node(self, node: LeastRecentlyUsedCacheItem) -> None:
        """Remove a node from its current position in the list."""
        prev_node = node.prev
        next_node = node.next
        if prev_node and next_node:  # Type checking
            prev_node.next = next_node
            next_node.prev = prev_node
    
    def _add_to_head(self, node: LeastRecentlyUsedCacheItem) -> None:
        """Add a node to the head of the list (most recently used)."""
        node.next = self.head.next
        node.prev = self.head
        if self.head.next:  # Type checking
            self.head.next.prev = node
        self.head.next = node
    
    def _move_to_head(self, node: LeastRecentlyUsedCacheItem) -> None:
        """Move an existing node to the head of the list."""
        self._remove_node(node)
        self._add_to_head(node)
    
    def get(self, key: str) -> Optional[Any]:
        """Retrieve an item from the cache by key.
        
        Args:
            key: The key to look up
            
        Returns:
            The value associated with the key, or None if not found
        """
        if key not in self.cache:
            return None
            
        node = self.cache[key]
        self._move_to_head(node)
        return node.value
    
    def put(self, key: str, value: Any) -> None:
        """Add or update an item in the cache.
        
        Args:
            key: The key to store the value under
            value: The value to store
        """
        if key in self.cache:
            # Update existing node
            node = self.cache[key]
            node.value = value
            self._move_to_head(node)
        else:
            # Create new node
            node = LeastRecentlyUsedCacheItem(key, value)
            self.cache[key] = node
            self._add_to_head(node)
            
            # Remove least recently used if at capacity
            if len(self.cache) > self.capacity:
                if self.tail.prev:  # Type checking
                    lru_node = self.tail.prev
                    self._remove_node(lru_node)
                    del self.cache[lru_node.key]
