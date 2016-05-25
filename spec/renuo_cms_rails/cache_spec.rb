require 'spec_helper'

describe RenuoCmsRails::Cache do
  describe '#cache' do
    it 'returns a cache instance' do
      expect(described_class.cache).to be_a(RenuoCmsRails::Cache::Cacher)
    end

    it 'returns the same instance two times' do
      expect(described_class.cache).to be(described_class.cache)
    end
  end

  describe '#initialize_cache' do
    it 'delegates the method call initialize_cache to the cacher' do
      expect(described_class.cache).to receive(:initialize_cache)
      described_class.initialize_cache
    end
  end

  describe '#get' do
    it 'delegates the method call get(key) to the cacher' do
      expect(described_class.cache).to receive(:get).with('content.path')
      described_class.get('content.path')
    end
  end
end
