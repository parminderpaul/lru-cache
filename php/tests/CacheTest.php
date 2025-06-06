<?php

namespace LeastRecentlyUsed\Tests;

use LeastRecentlyUsed\Cache;
use PHPUnit\Framework\TestCase;

class CacheTest extends TestCase {
	private $cache;

	protected function setUp(): void {
		$this->cache = new Cache(2);
	}

	public function testConstructorThrowsExceptionForInvalidCapacity(): void {
		$this->expectException(\InvalidArgumentException::class);
		new Cache(0);
	}

	public function testPutAndGet(): void {
		$this->cache->put("key1", "value1");
		$this->assertEquals("value1", $this->cache->get("key1"));
	}

	public function testGetNonExistentKey(): void {
		$this->assertNull($this->cache->get("nonexistent"));
	}

	public function testUpdateExistingKey(): void {
		$this->cache->put("key1", "value1");
		$this->cache->put("key1", "new_value1");
		$this->assertEquals("new_value1", $this->cache->get("key1"));
	}

	public function testLRUEviction(): void {
		$this->cache->put("key1", "value1");
		$this->cache->put("key2", "value2");
		$this->cache->put("key3", "value3");

		// key1 should be evicted as it was least recently used
		$this->assertNull($this->cache->get("key1"));
		$this->assertEquals("value2", $this->cache->get("key2"));
		$this->assertEquals("value3", $this->cache->get("key3"));
	}

	public function testAccessOrderAffectsEviction(): void {
		$this->cache->put("key1", "value1");
		$this->cache->put("key2", "value2");
		
		// Access key1 to make it most recently used
		$this->cache->get("key1");
		
		// Add key3, which should evict key2 (least recently used)
		$this->cache->put("key3", "value3");
		
		$this->assertEquals("value1", $this->cache->get("key1"));
		$this->assertNull($this->cache->get("key2"));
		$this->assertEquals("value3", $this->cache->get("key3"));
	}

	public function testUpdateMakesKeyMostRecentlyUsed(): void {
		$this->cache->put("key1", "value1");
		$this->cache->put("key2", "value2");
		
		// Update key1 to make it most recently used
		$this->cache->put("key1", "new_value1");
		
		// Add key3, which should evict key2 (least recently used)
		$this->cache->put("key3", "value3");
		
		$this->assertEquals("new_value1", $this->cache->get("key1"));
		$this->assertNull($this->cache->get("key2"));
		$this->assertEquals("value3", $this->cache->get("key3"));
	}
}
