module RenuoCmsRails
  module Cache
    class Cacher
      def initialize(api = nil)
        @api = api
      end

      def initialize_cache
        @contents = @api.load_contents
      end

      # :reek:UnusedParameters
      def get(content_path)
      end
    end
  end
end
