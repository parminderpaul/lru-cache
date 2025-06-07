# OOP LRU Cache in Java

This directory contains a Java implementation of the LRU Cache project specified in the parent
directory's `README.md`. To build and test it, run `build.bat` (Windows) or `build.sh` (others).
This will:

1. Download JUnit to `lib/`, if necessary.
2. Compile the two classes and the unit tests.
3. Run the unit tests.

## Requirements

- Java

## Usage

```java
// Create a new cache with capacity of 3
LeastRecentlyUsedCache cache = new LeastRecentlyUsedCache(3);

// Add items to the cache
cache.put("key1", "value1");
cache.put("key2", "value2");
cache.put("key3", "value3");

// Retrieve items
String value = cache.get("key1"); // Returns "value1"

// Adding a new item when cache is full removes the least recently used item
cache.put("key4", "value4"); // Removes "key2" because this was least recently used

// Updating an existing key makes it most recently used
cache.put("key3", "new_value3"); // Updates value and makes key3 most recently used
```

## Notes

This project didn't seem large enough to justify adding e.g. Gradle or Maven to manage the build
and test process, so I just added scripts.

Most other implementations in this project use either a generic object (for loosely-typed languages
PHP, Python, and Ruby) or else an interface (in not-really-OOP Go) to represent the stored item.
However, this implementation (and TypeScript's) uses Generics.

This means that you'll want to specify the type of object that you'll be caching upon
instantiation, although this can be a generic superclass (e.g. `<Object>`) or specific complex
object, e.g.:

```java
public class Page {
	private final string slug;
	private string title;
  private string content;

  // ...
}

LeastRecentlyUsedCache<Page> pageCache = new LeastRecentlyUsedCache<Page>(100);
```
