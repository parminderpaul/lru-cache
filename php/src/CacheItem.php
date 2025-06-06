<?php

namespace LeastRecentlyUsed;

class CacheItem {
	public $key;
	public $value;
	public $prev;
	public $next;

	public function __construct(string $key, mixed $value) {
		$this->key   = $key;
		$this->value = $value;
		$this->prev  = null;
		$this->next  = null;
	}
}
