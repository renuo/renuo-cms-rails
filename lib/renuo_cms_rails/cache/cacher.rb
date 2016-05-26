module RenuoCmsRails
  module Cache
    class Cacher
      def initialize(api)
        @api = api
      end

      def initialize_cache
        @contents = @api.fetch_contents
      end

      def get(content_path)
        return unless @contents
        @contents[content_path]
      end
    end
  end
end
