require_relative 'cache/cacher'

module RenuoCmsRails
  module Cache
    @cache = Cacher.new

    attr_reader :cache

    # Initializes the cache. This will connect via HTTPS to the configured CMS host, so make sure that the host is
    # configured prior to calling this method.
    delegate :initialize_cache, to: :cache

    # Gets the content if the content with the content_path is in the cache, nil otherwise.
    # @param [String] content_path
    # @return [String]
    delegate :get, to: :cache

    module_function :cache, :get, :initialize_cache
  end
end
