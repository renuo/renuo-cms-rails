module RenuoCmsRails
  module API
    class Contents
      MAX_CACHE_TTL = 60 * 2 # 2 minutes

      # @param [RenuoCmsRails::Config] config
      def initialize(config)
        @config = config
      end

      def url
        "#{@config.api_host_with_protocol}/v1/#{@config.api_key}/content_blocks?_=#{cache_time}"
      end

      # :reek:UtilityFunction
      def cache_time
        # note: using integer division for rounding, so that we get a new key every 2 minutes, e.g.
        # part 1: 249 / 120 = 2 (not 2.075)
        # part 2: 2 * 120 = 240
        # all: (249 / 120) * 120 = 240
        (Time.now.to_i / MAX_CACHE_TTL) * MAX_CACHE_TTL
      end

      def fetch
        uri = URI(url)
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          handle_response(http.request(request))
        end
      end

      private

      def handle_response(response)
        return {} unless response.is_a?(Net::HTTPOK)
        convert_json(response)
      end

      # :reek:UtilityFunction
      def convert_json(response)
        content_blocks_json = JSON.parse(response.body)['content_blocks']
        return {} unless content_blocks_json
        content_blocks_json.map { |block_json| [block_json['content_path'], block_json['content']] }.to_h
      rescue JSON::ParserError
        {}
      end
    end
  end
end
