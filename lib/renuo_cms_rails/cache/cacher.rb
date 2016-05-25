module RenuoCmsRails
  module Cache
    class Cacher
      def initialize(api = nil)
        @api = api
      end

      def initialize_cache
        @contents = @api.load_contents
      end

      def get(content_path)
        return unless @contents
        @contents[content_path]
      end
    end
  end
end
