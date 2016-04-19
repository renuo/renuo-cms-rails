require File.expand_path('../lib/renuo_cms_rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lukas Elmer']
  gem.email         = ['lukas.elmer@renuo.ch']
  gem.description   = %q{Renuo CMS Rails}
  gem.summary       = %q{Rails helpers for the renuo-cms}
  gem.homepage      = 'https://github.com/sgruhier/renuo_cms_rails'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'renuo_cms_rails'
  gem.require_paths = ['lib']
  gem.version       = RenuoCmsRails::VERSION
  gem.license       = 'MIT'

  gem.add_dependency 'railties',      '~> 4.1'
  gem.add_dependency 'actionpack',    '~> 4.1'
  gem.add_dependency 'activemodel',   '~> 4.1'
  gem.add_dependency 'activesupport', '~> 4.1'
  gem.add_dependency 'tzinfo',        '~> 1.2', '>= 1.2.2'

  gem.add_development_dependency 'rspec-rails',     '~> 3.1', '>= 3.1.0'
  gem.add_development_dependency 'mime-types',      '~> 2'
  gem.add_development_dependency 'capybara',        '~> 2.4', '>= 2.4.3'
  gem.add_development_dependency 'climate_control', '~> 0', '>= 0.0.3'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'reek'
end
