require 'spec_helper'
require 'timecop'

describe RenuoCmsRails::API::Contents do
  before do
    config = RenuoCmsRails::Config.new
    config.api_host = 'example.com'
    config.api_key = 'somekey'
    config.private_api_key = 'pk'
    @contents_api = RenuoCmsRails::API::Contents.new(config)
  end

  describe '#build_url' do
    it 'calculates the correct cache time' do
      Timecop.freeze(Time.at(10).utc) { expect(@contents_api.cache_time).to eq(0) }
      Timecop.freeze(Time.at(60).utc) { expect(@contents_api.cache_time).to eq(0) }
      Timecop.freeze(Time.at(90).utc) { expect(@contents_api.cache_time).to eq(0) }
      Timecop.freeze(Time.at(119).utc) { expect(@contents_api.cache_time).to eq(0) }
      Timecop.freeze(Time.at(120).utc) { expect(@contents_api.cache_time).to eq(120) }
      Timecop.freeze(Time.at(121).utc) { expect(@contents_api.cache_time).to eq(120) }
      Timecop.freeze(Time.at(239).utc) { expect(@contents_api.cache_time).to eq(120) }
      Timecop.freeze(Time.at(240).utc) { expect(@contents_api.cache_time).to eq(240) }
      Timecop.freeze(Time.at(240).utc) { expect(@contents_api.cache_time).to eq(240) }
      Timecop.freeze(Time.at(959).utc) { expect(@contents_api.cache_time).to eq(840) }
      Timecop.freeze(Time.at(960).utc) { expect(@contents_api.cache_time).to eq(960) }
      Timecop.freeze(Time.at(961).utc) { expect(@contents_api.cache_time).to eq(960) }
    end

    describe '#url' do
      it 'builds the correct url' do
        Timecop.freeze(Time.at(123).utc) do
          url = 'https://example.com/v1/somekey/content_blocks?_=120'
          expect(@contents_api.url).to eq(url)
        end
      end
    end

    describe '#fetch' do
      def valid_api_response
        time_json = '"updated_at":"2016-04-11T12:30:38.029Z","created_at":"2016-01-11T12:30:38.029Z"'
        cb1 = "{\"content\":\"content1\",\"content_path\":\"path1\",\"api_key\":\"somekey\",#{time_json}}"
        cb2 = "{\"content\":\"content2\",\"content_path\":\"path2\",\"api_key\":\"somekey\",#{time_json}}"
        "{\"content_blocks\":[#{cb1}, #{cb2}]}"
      end

      def test_request(contents_api, api_response)
        Timecop.freeze(Time.at(123).utc) do
          stub_request(:get, contents_api.url).with(headers: { 'Host' => 'example.com' }).to_return(body: api_response)
          return contents_api.fetch
        end
      end

      it 'fetches the contents via HTTPS' do
        contents = test_request(@contents_api, valid_api_response)
        expect(contents['path1']).to eq('content1')
        expect(contents['path2']).to eq('content2')
        expect(contents['path3']).to eq(nil)
      end

      it 'fetches the contents via HTTP' do
        config = RenuoCmsRails::Config.new
        config.api_host = 'http://example.com'
        config.api_key = 'somekey'
        config.private_api_key = 'pk'
        contents_api = RenuoCmsRails::API::Contents.new(config)
        contents = test_request(contents_api, valid_api_response)
        expect(contents['path1']).to eq('content1')
        expect(contents['path2']).to eq('content2')
        expect(contents['path3']).to eq(nil)
      end

      it 'returns an empty hash if the JSON is invalid' do
        config = RenuoCmsRails::Config.new
        config.api_host = 'http://example.com'
        config.api_key = 'somekey'
        config.private_api_key = 'pk'
        contents_api = RenuoCmsRails::API::Contents.new(config)
        expect(test_request(contents_api, '{{invalid json')).to eq({})
      end

      it 'returns an empty hash if the JSON is not complete' do
        config = RenuoCmsRails::Config.new
        config.api_host = 'http://example.com'
        config.api_key = 'somekey'
        config.private_api_key = 'pk'
        contents_api = RenuoCmsRails::API::Contents.new(config)
        expect(test_request(contents_api, '{"missing":"stuff"}')).to eq({})
      end

      it 'returns an empty hash if the API request was not successful' do
        config = RenuoCmsRails::Config.new
        config.api_host = 'http://example.com'
        config.api_key = 'somekey'
        config.private_api_key = 'pk'
        contents_api = RenuoCmsRails::API::Contents.new(config)

        Timecop.freeze(Time.at(123).utc) do
          stub_request(:get, contents_api.url).with(headers: { 'Host' => 'example.com' }).to_return(
            status: [500, 'Internal Server Error']
          )
          expect(contents_api.fetch).to eq({})
        end
      end
    end
  end
end
