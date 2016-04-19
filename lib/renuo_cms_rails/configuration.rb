module RenuoCmsRails
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_host
    attr_accessor :api_key
    attr_accessor :private_api_key

    def initialize
      self.api_host = ENV['RENUO_CMS_API_HOST']
      self.api_key = ENV['RENUO_CMS_API_KEY']
      self.private_api_key = ENV['RENUO_CMS_PRIVATE_API_KEY']
    end
  end
end
