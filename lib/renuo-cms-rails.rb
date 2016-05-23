require 'renuo_cms_rails/version'
require 'renuo_cms_rails/configuration'
require 'renuo_cms_rails/cms_helper'

ActiveSupport.on_load(:action_view) do
  include RenuoCmsRails::CmsHelper
end
