from typing import Any, Optional

class LeastRecentlyUsedCacheItem:
    """Item class for doubly-linked list implementation."""
    
    def __init__(self, key: str, value: Any):
        self.key = key
        self.value = value
        self.prev: Optional[LeastRecentlyUsedCacheItem] = None
        self.next: Optional[LeastRecentlyUsedCacheItem] = None
