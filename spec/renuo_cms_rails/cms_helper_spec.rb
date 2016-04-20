require 'spec_helper'

describe RenuoCmsRails::CmsHelper do
  include RenuoCmsRails::CmsHelper
  include ActionView::Helpers::TagHelper
  include RenuoCmsRailsSpecHelper

  before(:each) do
    RenuoCmsRails.config.api_host = 'some.host'
    RenuoCmsRails.config.api_key = 'apikey'
    RenuoCmsRails.config.private_api_key = 'pk'
  end

  it 'sets the correct attributes for the public view' do
    allow(self).to receive(:cms_admin?).and_return(false)

    node = Capybara.string cms('some.content', 'Some CMS content')
    expect(node).to have_css('div', text: 'Some CMS content')
    expect(node).to have_css("div[data-content-path='some.content-en']")
    expect(node).to have_css("div[data-api-host='some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).not_to have_css('div[data-private-api-key]')
  end

  it 'sets the correct attributes for the admin view' do
    allow(self).to receive(:cms_admin?).and_return(true)

    node = Capybara.string cms('some.content', 'Some CMS content')
    expect(node).to have_css('div', text: 'Some CMS content')
    expect(node).to have_css("div[data-content-path='some.content-en']")
    expect(node).to have_css("div[data-api-host='some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).to have_css("div[data-private-api-key='pk']")
  end

  it 'captures a block' do
    allow(self).to receive(:cms_admin?).and_return(false)

    node = Capybara.string cms('some.content') { content_tag('p', 'Block content!') }
    expect(node).not_to have_css('div', text: 'Some CMS content')
    expect(node).to have_css('div p', text: 'Block content!')
    expect(node).to have_css("div[data-content-path='some.content-en']")
    expect(node).to have_css("div[data-api-host='some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).not_to have_css('div[data-private-api-key]')
  end

  it 'translates a key as content' do
    allow(self).to receive(:cms_admin?).and_return(false)

    I18n.backend.store_translations :en, some: { content: 'I18n.t content!' }
    node = Capybara.string cms('some.content')
    expect(node).to have_css('div', text: 'I18n.t content!')
    expect(node).to have_css("div[data-content-path='some.content-en']")
    expect(node).to have_css("div[data-api-host='some.host']")
    expect(node).to have_css("div[data-api-key='apikey']")
    expect(node).not_to have_css('div[data-private-api-key]')
  end
end
