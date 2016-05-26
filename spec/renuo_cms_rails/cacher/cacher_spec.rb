require 'spec_helper'

describe RenuoCmsRails::Cache::Cacher do
  describe '#initialize_cache' do
    it 'calls the api to initialize the cache' do
      api = double(fetch_contents: 'contents')
      cacher = described_class.new(api)
      expect(api).to receive(:fetch_contents)
      cacher.initialize_cache
      expect(cacher.instance_variable_get('@contents')).to eq('contents')
    end
  end

  describe '#get' do
    it 'gets the cached content' do
      cacher = described_class.new(nil)
      cacher.instance_variable_set('@contents', 'a' => 'aa', 'b' => 'bb')
      expect(cacher.get('a')).to eq('aa')
      expect(cacher.get('b')).to eq('bb')
      expect(cacher.get('c')).to eq(nil)
    end

    it 'gets returns nil if the cache is not initialized' do
      cacher = described_class.new(nil)
      expect(cacher.get('a')).to eq(nil)
    end
  end
end
