require 'action_view/helpers'

module RenuoCmsRails
  module CmsHelper
    def cms(path, default_value = nil, &block)
      content_path = RenuoCmsRails.config.content_path_generator.call(path)
      default_translation = capture_default_value(path, default_value, &block)
      content_tag(:div, default_translation, data: cms_attributes(content_path))
    end

    private

    # :reek:FeatureEnvy
    def cms_attributes(content_path)
      config = RenuoCmsRails.config
      cms_attributes = { content_path: content_path, api_host: config.api_host, api_key: config.api_key }
      cms_attributes[:private_api_key] = config.private_api_key if cms_admin?
      cms_attributes
    end

    def capture_default_value(path, default_value)
      return default_value if default_value
      return capture { yield } if block_given?

      I18n.t(path)
    end
  end
end
