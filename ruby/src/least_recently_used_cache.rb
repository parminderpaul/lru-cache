# frozen_string_literal: true

require_relative 'least_recently_used_cache_item'

# Implementation of a Least Recently Used (LRU) cache using a Hash for O(1) lookups
# and a doubly-linked list for maintaining the order of items by their usage.
class LeastRecentlyUsedCache
  def initialize(capacity)
    raise ArgumentError, 'Cache capacity must be at least 1' if capacity < 1

    @capacity = capacity
    @cache = {}
    @head = nil  # Most recently used
    @tail = nil  # Least recently used
  end

  # Adds or updates a value in the cache. If the key already exists, its value is updated
  # and it becomes the most recently used item. If the cache is full, the least recently
  # used item is removed before adding the new item.
  def put(key, value)
    if @cache.key?(key)
      # If key exists, update it and move to front
      old_item = @cache[key]
      remove_from_list(old_item)
      new_item = LeastRecentlyUsedCacheItem.new(key, value)
      add_to_front(new_item)
      @cache[key] = new_item
      return
    end

    # If cache is full, remove least recently used item
    remove_least_recently_used if @cache.size >= @capacity

    # Add new item
    new_item = LeastRecentlyUsedCacheItem.new(key, value)
    add_to_front(new_item)
    @cache[key] = new_item
  end

  # Retrieves a value from the cache. If the key exists, the item becomes the most
  # recently used item. If the key doesn't exist, raises an ArgumentError.
  def get(key)
    item = @cache[key]
    raise ArgumentError, "Key not found in cache: #{key}" if item.nil?

    # Move to front of list (most recently used)
    remove_from_list(item)
    add_to_front(item)
    item.value
  end

  private

  def remove_least_recently_used
    return if @tail.nil?

    @cache.delete(@tail.key)
    remove_from_list(@tail)
  end

  def remove_from_list(item)
    return if item.nil?

    # Update prev item's next pointer
    if item.prev
      item.prev.next = item.next
    else
      # This was the head
      @head = item.next
    end

    # Update next item's prev pointer
    if item.next
      item.next.prev = item.prev
    else
      # This was the tail
      @tail = item.prev
    end

    # Clear the item's pointers
    item.next = nil
    item.prev = nil
  end

  def add_to_front(item)
    if @head.nil?
      # First item in the list
      @head = item
      @tail = item
    else
      # Add to front of list
      item.next = @head
      @head.prev = item
      @head = item
    end
  end
end
