import { LeastRecentlyUsedCache } from '../src/LeastRecentlyUsedCache';

describe('LeastRecentlyUsedCache', () => {
  it('should throw error when capacity is less than or equal to 0', () => {
    expect(() => new LeastRecentlyUsedCache(0)).toThrow('Cache capacity must be greater than 0');
    expect(() => new LeastRecentlyUsedCache(-1)).toThrow('Cache capacity must be greater than 0');
  });

  it('should initialize with correct capacity', () => {
    const cache = new LeastRecentlyUsedCache<number>(2);
    expect(cache.maxSize).toBe(2);
    expect(cache.size).toBe(0);
  });

  it('should put and get values correctly', () => {
    const cache = new LeastRecentlyUsedCache<number>(2);
    cache.put('key1', 1);
    cache.put('key2', 2);

    expect(cache.get('key1')).toBe(1);
    expect(cache.get('key2')).toBe(2);
    expect(cache.get('key3')).toBeNull();
  });

  it('should update value when putting same key', () => {
    const cache = new LeastRecentlyUsedCache<number>(2);
    cache.put('key1', 1);
    cache.put('key1', 2);

    expect(cache.get('key1')).toBe(2);
    expect(cache.size).toBe(1);
  });

  it('should evict least recently used item when capacity is exceeded', () => {
    const cache = new LeastRecentlyUsedCache<number>(2);
    cache.put('key1', 1);
    cache.put('key2', 2);
    cache.put('key3', 3);

    expect(cache.get('key1')).toBeNull();
    expect(cache.get('key2')).toBe(2);
    expect(cache.get('key3')).toBe(3);
  });

  it('should update LRU order on get operations', () => {
    const cache = new LeastRecentlyUsedCache<number>(2);
    cache.put('key1', 1);
    cache.put('key2', 2);

    // key1 becomes most recently used
    cache.get('key1');

    // key2 should be evicted
    cache.put('key3', 3);

    expect(cache.get('key1')).toBe(1);
    expect(cache.get('key2')).toBeNull();
    expect(cache.get('key3')).toBe(3);
  });

  it('should handle generic objects', () => {
    const cache = new LeastRecentlyUsedCache<object>(2);
    const obj1 = { id: 1, data: 'test1' };
    const obj2 = { id: 2, data: 'test2' };

    cache.put('obj1', obj1);
    cache.put('obj2', obj2);

    expect(cache.get('obj1')).toEqual(obj1);
    expect(cache.get('obj2')).toEqual(obj2);
  });

  it('should handle complex objects', () => {
    interface ComplexObject {
      id: number;
      data: string;
    }

    const cache = new LeastRecentlyUsedCache<ComplexObject>(2);
    const obj1 = { id: 1, data: 'test1' };
    const obj2 = { id: 2, data: 'test2' };

    cache.put('obj1', obj1);
    cache.put('obj2', obj2);

    expect(cache.get('obj1')).toEqual(obj1);
    expect(cache.get('obj2')).toEqual(obj2);
  });
});
