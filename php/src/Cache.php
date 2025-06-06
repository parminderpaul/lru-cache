<?php

namespace LeastRecentlyUsed;

class Cache {
	private $capacity;
	private $cache = [];
	private $head = null;
	private $tail = null;

	/**
	 * Constructor for Cache
	 * @param int $capacity The maximum number of items the cache can hold
	 * @throws \InvalidArgumentException if capacity is not 1+
	 */
	public function __construct(int $capacity) {
		if ($capacity <= 0) throw new \InvalidArgumentException("Cache capacity must be at least 1");
		$this->capacity = $capacity;
	}

	/**
	 * Get an item from the cache
	 * @param string $key The key to look up
	 * @return mixed|null The value if found, null otherwise
	 */
	public function get(string $key): mixed {
		if (!isset($this->cache[$key])) return null;

		$node = $this->cache[$key];
		$this->moveToFront($node);
		return $node->value;
	}

	/**
	 * Put an item into the cache
	 * @param string $key The key to store the value under
	 * @param mixed $value The value to store
	 */
	public function put(string $key, mixed $value): void {
		if (isset($this->cache[$key])) {
			$node = $this->cache[$key];
			$node->value = $value;
			$this->moveToFront($node);
			return;
		}

		$node = new CacheItem($key, $value);
		$this->cache[$key] = $node;
		$this->addToFront($node);

		if (count($this->cache) > $this->capacity) $this->removeLast();
	}

	/**
	 * Move a node to the front of the list (most recently used)
	 * @param CacheItem $node The node to move
	 */
	private function moveToFront(CacheItem $node): void {
		if ($node === $this->head) return;

		// Remove node from its current position
		if ($node->prev) $node->prev->next = $node->next;
		if ($node->next) $node->next->prev = $node->prev;
		if ($node === $this->tail) $this->tail = $node->prev;

		$this->addToFront($node);
	}

	/**
	 * Add a node to the front of the list
	 * @param CacheItem $node The node to add
	 */
	private function addToFront(CacheItem $node): void {
		$node->next = $this->head;
		$node->prev = null;

		if ($this->head) $this->head->prev = $node;
		$this->head = $node;

		if ($this->tail === null) $this->tail = $node;
	}

	/**
	 * Remove the least recently used item from the cache
	 */
	private function removeLast(): void {
		if ($this->tail === null) return;

		$key = $this->tail->key;
		unset($this->cache[$key]);

		if ($this->head === $this->tail) {
			$this->head = null;
			$this->tail = null;
			return;
		}

		$this->tail = $this->tail->prev;
		$this->tail->next = null;
	}
}
