require_relative 'api/contents'

module RenuoCmsRails
  module API
    # Fetches the contents from the API. It returns a hash where the key is the content_path and the value is the
    # content string.
    # @return [Hash<String, String>] the contents from the API
    def fetch_contents
      Contents.new(RenuoCmsRails.config).fetch
    end

    module_function :fetch_contents
  end
end
