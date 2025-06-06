require 'spec_helper'

RSpec.describe LeastRecentlyUsedCache do
  describe '#initialize' do
    it 'creates a cache with valid capacity' do
      cache = described_class.new(5)
      expect(cache).to be_a(LeastRecentlyUsedCache)
    end

    it 'raises ArgumentError for capacity 0' do
      expect { described_class.new(0) }.to raise_error(ArgumentError, 'Cache capacity must be at least 1')
    end

    it 'raises ArgumentError for negative capacity' do
      expect { described_class.new(-1) }.to raise_error(ArgumentError, 'Cache capacity must be at least 1')
    end
  end

  describe '#put and #get' do
    let(:cache) { described_class.new(3) }

    it 'performs basic put and get operations' do
      cache.put('key1', 'value1')
      expect(cache.get('key1')).to eq('value1')
    end

    it 'updates existing key' do
      cache.put('key1', 'value1')
      cache.put('key1', 'newValue1')
      expect(cache.get('key1')).to eq('newValue1')
    end

    it 'raises ArgumentError for non-existent key' do
      expect { cache.get('nonexistent') }.to raise_error(ArgumentError, 'Key not found in cache: nonexistent')
    end
  end

  describe 'LRU behavior' do
    let(:cache) { described_class.new(3) }

    it 'removes least recently used item when cache is full' do
      # Fill the cache
      cache.put('key1', 'value1')
      cache.put('key2', 'value2')
      cache.put('key3', 'value3')

      # Verify all items are present
      expect(cache.get('key1')).to eq('value1')
      expect(cache.get('key2')).to eq('value2')
      expect(cache.get('key3')).to eq('value3')

      # Add one more item, should remove key1 (least recently used)
      cache.put('key4', 'value4')
      expect { cache.get('key1') }.to raise_error(ArgumentError, 'Key not found in cache: key1')

      # Verify other items are still present
      expect(cache.get('key2')).to eq('value2')
      expect(cache.get('key3')).to eq('value3')
      expect(cache.get('key4')).to eq('value4')
    end
  end

  describe 'access order' do
    let(:cache) { described_class.new(3) }

    it 'maintains correct access order' do
      # Fill the cache
      cache.put('key1', 'value1')
      cache.put('key2', 'value2')
      cache.put('key3', 'value3')

      # Access key1, making key2 the least recently used
      cache.get('key1')

      # Add new item, should remove key2
      cache.put('key4', 'value4')
      expect { cache.get('key2') }.to raise_error(ArgumentError, 'Key not found in cache: key2')

      # Verify remaining items
      expect(cache.get('key1')).to eq('value1')
      expect(cache.get('key3')).to eq('value3')
      expect(cache.get('key4')).to eq('value4')
    end
  end

  describe 'update existing key' do
    let(:cache) { described_class.new(2) }

    it 'updates existing key and maintains correct order' do
      # Add two items
      cache.put('key1', 'value1')
      cache.put('key2', 'value2')

      # Update key1, making key2 the least recently used
      cache.put('key1', 'newValue1')

      # Add new item, should remove key2
      cache.put('key3', 'value3')
      expect { cache.get('key2') }.to raise_error(ArgumentError, 'Key not found in cache: key2')

      # Verify remaining items
      expect(cache.get('key1')).to eq('newValue1')
      expect(cache.get('key3')).to eq('value3')
    end
  end
end 