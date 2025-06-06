# OOP LRU Cache in PHP

This directory contains a PHP implementation of the LRU Cache project specified in the parent
directory's `README.md`. To install its dependencies and test it, run
`composer install && ./vendor/bin/phpunit tests`.

## Requirements

- PHP 8.3+
- Composer

## Usage

To use the LRU Cache in your PHP project:

```php
// Create a new cache with capacity of 3
$cache = new \LeastRecentlyUsed\Cache(3);

// Add items to the cache
$cache->put("key1", "value1");
$cache->put("key2", "value2");
$cache->put("key3", "value3");

// Retrieve items
$value = $cache->get("key1");  // Returns "value1"

// Adding a new item when cache is full removes the least recently used item
$cache->put("key4", "value4"); // Removes "key2" because this was least recently used

// Updating an existing key makes it most recently used
$cache->put("key3", "new_value3"); // Updates value and makes key3 most recently used
```

## Note

The code itself is compatible back to PHP 8.1+ (which added intersection type hints), but I'm using
PHPUnit v12, which requires PHP 8.3+. If you're using an older version of PHP than me, you can
download PHPUnit in `composer.json` to a
[compatible version](https://phpunit.de/supported-versions.html).
