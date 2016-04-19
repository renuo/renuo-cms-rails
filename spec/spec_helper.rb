Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
require 'renuo_cms_rails'
require 'capybara'
require 'climate_control'

# turning off deprecations
ActiveSupport::Deprecation.silenced = true
I18n.enforce_available_locales = false
