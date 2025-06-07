import { LeastRecentlyUsedCacheItem } from './LeastRecentlyUsedCacheItem';

export class LeastRecentlyUsedCache<T> {
  private capacity: number;
  private cache: Map<string, LeastRecentlyUsedCacheItem<T>>;
  private head: LeastRecentlyUsedCacheItem<T> | null;
  private tail: LeastRecentlyUsedCacheItem<T> | null;

  /**
   * Create a new Least Recently Used Cache with a specified capacity.
   * If an item is added to the cache when it is full, the least recently used (added or accessed)
   * item will be removed to make room for the new item. Items are keyed by strings.
   *
   * @param capacity: number - The maximum number of items that the cache can hold.
   */
  constructor(capacity: number) {
    if (capacity <= 0) {
      throw new Error('Cache capacity must be greater than 0');
    }
    this.capacity = capacity;
    this.cache = new Map();
    this.head = null;
    this.tail = null;
  }

  private moveToHead(node: LeastRecentlyUsedCacheItem<T>): void {
    if (node === this.head) return;

    // Remove node from its current position
    if (node.prev) node.prev.next = node.next;
    if (node.next) node.next.prev = node.prev;
    if (node === this.tail) this.tail = node.prev;

    // Move node to head
    node.prev = null;
    node.next = this.head;
    if (this.head) this.head.prev = node;
    this.head = node;
    if (!this.tail) this.tail = node;
  }

  /**
   * Get the value of an item from the cache. If the item does not exist, null is returned.
   *
   * @param key: string - The key of the item to get.
   * @returns The value of the item, or null if the item does not exist.
   */
  get(key: string): T | null {
    const node = this.cache.get(key);
    if (!node) return null;

    this.moveToHead(node);
    return node.value;
  }

  /**
   * Add an item to the cache. If the item already exists, it will be updated.
   *
   * @param key: string - The key of the item to add.
   * @param value - The value of the item to add.
   */
  put(key: string, value: T): void {
    const existingNode = this.cache.get(key);

    if (existingNode) {
      existingNode.value = value;
      this.moveToHead(existingNode);
      return;
    }

    const newNode = new LeastRecentlyUsedCacheItem(key, value);
    this.cache.set(key, newNode);

    if (!this.head) {
      this.head = newNode;
      this.tail = newNode;
    } else {
      this.moveToHead(newNode);
    }

    if (this.cache.size > this.capacity) {
      if (this.tail) {
        this.cache.delete(this.tail.key);
        this.tail = this.tail.prev;
        if (this.tail) this.tail.next = null;
      }
    }
  }

  /**
   * Get the current number of items in the cache.
   *
   * @returns The number of items in the cache.
   */
  get size(): number {
    return this.cache.size;
  }

  /**
   * Get the capacity of the cache.
   *
   * @returns The maximum number of items that the cache can hold.
   */
  get maxSize(): number {
    return this.capacity;
  }
}
