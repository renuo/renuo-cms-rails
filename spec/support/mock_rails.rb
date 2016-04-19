require 'bundler/setup'
require 'action_view'

module RenuoCmsRailsSpecHelper
  include ActionView::Context if defined?(ActionView::Context)
end
