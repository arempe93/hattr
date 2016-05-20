#!/usr/bin/env gem build
# encoding: utf-8

require 'base64'
require File.expand_path("../lib/hattr/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'hattr'
  s.version     = Hattr::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andrew Rempe']
  s.email       = [Base64.decode64('YW5kcmV3cmVtcGVAZ21haWwuY29t\n')]
  s.summary     = 'PSQL hstore attributes'
  s.description = 'A translation for the string centric hstore extension'
  s.license     = 'MIT'

  s.required_ruby_version = Gem::Requirement.new '>= 1.9.3'

  s.add_dependency 'activesupport', '>= 3.0.0'

  s.add_development_dependency 'rake', '~> 10.5.0'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rspec', '~> 3.4.0'
  s.add_development_dependency 'coveralls'

  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- spec/*`.split "\n"
  s.require_paths = [ 'lib' ]
end
