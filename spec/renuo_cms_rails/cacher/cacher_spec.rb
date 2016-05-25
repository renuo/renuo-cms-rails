require 'spec_helper'

describe RenuoCmsRails::Cache::Cacher do
  describe '#initialize_cache' do
    it 'calls the api to initialize the cache' do
      api = double(load_contents: 'contents')
      cacher = described_class.new(api)
      expect(api).to receive(:load_contents)
      cacher.initialize_cache
      expect(cacher.instance_variable_get('@contents')).to eq('contents')
    end
  end
end
