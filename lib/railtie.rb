module Railtie
  class Railtie < Rails::Railtie
    initializer 'renuo_cms_rails' do |app|
      app.config.after_initialize do
        require 'benchmark'
        require 'digest/sha1'

        time = Benchmark.measure do
          Rails.logger.info 'Initializing Renuo CMS Rails Cache...'
          cache = RenuoCmsRails::Cache.initialize_cache
          cache_details = "found #{cache.size} contents, sha1: #{Digest::SHA1.hexdigest(cache.to_s)}"
          Rails.logger.info "CMS cache details: #{cache_details}"
        end
        Rails.logger.info "Done initializing Renuo CMS Rails Cache (#{time.real.round(3)}s)"
      end
    end
  end
end
