export class LeastRecentlyUsedCacheItem<T> {
  key: string;
  value: T;
  prev: LeastRecentlyUsedCacheItem<T> | null;
  next: LeastRecentlyUsedCacheItem<T> | null;

  constructor(key: string, value: T) {
    this.key = key;
    this.value = value;
    this.prev = null;
    this.next = null;
  }
}
