Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
require 'renuo-cms-rails'
require 'capybara'
require 'climate_control'
require 'webmock/rspec'
