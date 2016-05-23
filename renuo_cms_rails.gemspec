lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'renuo_cms_rails/version'

Gem::Specification.new do |spec|
  spec.name = 'renuo-cms-rails'
  spec.version = RenuoCmsRails::VERSION
  spec.authors = ['Lukas Elmer']
  spec.email = ['lukas.elmer@renuo.ch']

  spec.summary = 'Rails helpers for the renuo-cms'
  spec.description = 'The Renuo CLI automates some commonly used workflows by providing a command line interface.'
  spec.homepage = 'https://github.com/renuo/renuo-cms-rails'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  spec.add_dependency 'railties',      '>= 4.1.0'
  spec.add_dependency 'actionpack',    '>= 4.1.0'
  spec.add_dependency 'activemodel',   '>= 4.1.0'
  spec.add_dependency 'activesupport', '>= 4.1.0'
  spec.add_dependency 'tzinfo',        '>= 1.2.2'

  spec.add_development_dependency 'rspec-rails',      '>= 3.4.2'
  spec.add_development_dependency 'mime-types',       '>= 2.99.1'
  spec.add_development_dependency 'capybara',         '>= 2.7.0'
  spec.add_development_dependency 'climate_control',  '>= 0.0.3'
  spec.add_development_dependency 'rubocop',          '>= 0.39.0'
  spec.add_development_dependency 'reek',             '>= 4.0.1'
end
