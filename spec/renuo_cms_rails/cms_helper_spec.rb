require 'spec_helper'

describe RenuoCmsRails::CmsHelper do
  include RenuoCmsRails::CmsHelper
  include ActionView::Helpers::TagHelper
  include RenuoCmsRailsSpecHelper

  before(:each) do
    RenuoCmsRails.reset
    RenuoCmsRails.config.api_host = 'some.host'
    RenuoCmsRails.config.api_key = 'apikey'
    RenuoCmsRails.config.private_api_key = 'pk'
  end

  it 'sets the correct attributes for the public view' do
    allow(self).to receive(:cms_admin?).and_return(false)

    node = Capybara.string cms('some.content', 'Some CMS content')
    expect(node).to have_css('div', text: 'Some CMS content')
    expect(node).to have_css("div[data-content-path='some-content-en']")
    expect(node).to have_css("div[data-api-host='https://some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).not_to have_css('div[data-private-api-key]')
  end

  it 'sets the correct attributes for the admin view' do
    allow(self).to receive(:cms_admin?).and_return(true)

    node = Capybara.string cms('some.content', 'Some CMS content')
    expect(node).to have_css('div', text: 'Some CMS content')
    expect(node).to have_css("div[data-content-path='some-content-en']")
    expect(node).to have_css("div[data-api-host='https://some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).to have_css("div[data-private-api-key='pk']")
  end
  describe '#capture_default_value' do
    it 'captures a block' do
      allow(self).to receive(:cms_admin?).and_return(false)

      node = Capybara.string cms('some.content') { content_tag('p', 'Block content!') }
      expect(node).not_to have_css('div', text: 'Some CMS content')
      expect(node).to have_css('div p', text: 'Block content!')
      expect(node).to have_css("div[data-content-path='some-content-en']")
      expect(node).to have_css("div[data-api-host='https://some.host']")
      expect(node).to have_css("div[data-api-key='apikey']")
      expect(node).not_to have_css('div[data-private-api-key]')
    end

    it 'translates a key as content' do
      allow(self).to receive(:cms_admin?).and_return(false)

      I18n.backend.store_translations :en, some: { content: 'I18n.t content!' }
      node = Capybara.string cms('some.content')
      expect(node).to have_css('div', text: 'I18n.t content!')
      expect(node).to have_css("div[data-content-path='some-content-en']")
      expect(node).to have_css("div[data-api-host='https://some.host']")
      expect(node).to have_css("div[data-api-key='apikey']")
      expect(node).not_to have_css('div[data-private-api-key]')
    end

    it 'uses the cache as prio 1' do
      allow(self).to receive(:cms_admin?).and_return(false)

      original = RenuoCmsRails::Cache.instance_variable_get('@cache')
      expect(original).to receive(:get).with('some-content-en').and_return('Cached content!')
      node1 = Capybara.string cms('some.content')
      expect(node1).to have_css('div', text: 'Cached content!')

      expect(original).to receive(:get).with('some-content-en').and_return('Cached content!')
      node2 = Capybara.string cms('some.content') { content_tag('p', 'Block content!') }
      expect(node2).to have_css('div', text: 'Cached content!')

      expect(original).to receive(:get).with('some-content-en').and_return('Cached content!')
      I18n.backend.store_translations :en, some: { content: 'I18n.t content!' }
      node3 = Capybara.string cms('some.content')
      expect(node3).to have_css('div', text: 'Cached content!')

      expect(original).to receive(:get).with('some-content-en').and_return('Cached content!')
      node4 = Capybara.string cms('some.content', 'default content')
      expect(node4).to have_css('div', text: 'Cached content!')
    end
  end

  it 'uses the custom content_path_generator config' do
    allow(self).to receive(:cms_admin?).and_return(false)

    RenuoCmsRails.config.content_path_generator = ->(path) { "#{I18n.locale}--#{path}" }

    node = Capybara.string cms('some.content', 'Some CMS content')
    expect(node).to have_css("div[data-content-path='en--some-content']")
  end
end
