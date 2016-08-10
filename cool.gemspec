# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cool/version'

Gem::Specification.new do |spec|
  spec.name          = 'cool'
  spec.version       = Cool::VERSION
  spec.authors       = ['Minwoo Lee']
  spec.email         = ['ermaker@gmail.com']
  spec.summary       = 'Cool Utilities'
  spec.description   = 'Cool Utilities'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rubycritic'
  spec.add_development_dependency 'guard-fasterer'
  spec.add_development_dependency 'guard-shell'
  spec.add_development_dependency 'rubycritic'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'coveralls'
end
