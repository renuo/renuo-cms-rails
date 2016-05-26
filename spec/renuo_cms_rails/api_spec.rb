require 'spec_helper'

describe RenuoCmsRails::API do
  describe '#fetch_contents' do
    it 'loads the contents' do
      RenuoCmsRails.reset
      RenuoCmsRails.config.api_host = 'example.com'
      RenuoCmsRails.config.api_key = 'apikey'
      RenuoCmsRails.config.private_api_key = 'pk'

      Timecop.freeze(Time.at(123).utc) do
        stub_request(:get, 'https://example.com/v1/apikey/content_blocks?_=120').with(
          headers: { 'Host' => 'example.com' }
        ).to_return(body: { content_blocks: [{ content: 'somecontent', content_path: 'somepath' }] }.to_json)
        contents = RenuoCmsRails::API.fetch_contents
        expect(contents['somepath']).to eq('somecontent')
      end
    end
  end
end
