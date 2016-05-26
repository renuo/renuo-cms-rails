require 'renuo_cms_rails/version'
require 'renuo_cms_rails/config'
require 'renuo_cms_rails/cms_helper'
require 'renuo_cms_rails/cache'
require 'renuo_cms_rails/api'

ActiveSupport.on_load(:action_view) do
  include RenuoCmsRails::CmsHelper
end
