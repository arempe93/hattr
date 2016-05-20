require 'rspec'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler'
Bundler.setup :default, :test
Bundler.require

require 'coveralls'
Coveralls.wear!

require 'hattr'

RSpec.configure do |config|
end
