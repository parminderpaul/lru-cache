# frozen_string_literal: true

# Represents a single item in the LRU cache, stored as a node in a doubly-linked list.
# Each item contains a key, value, and references to the next and previous items in the list.
class LeastRecentlyUsedCacheItem
  attr_reader :key, :value
  attr_accessor :next, :prev

  def initialize(key, value)
    @key = key
    @value = value
    @next = nil
    @prev = nil
  end
end
