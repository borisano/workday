require 'simplecov'
SimpleCov.start

require 'workday'
include Workday

require 'savon_spec'
require 'virtus-rspec'


RSpec.configure do |config|
  config.order = "random"

  config.include Virtus::Matchers

  config.include Savon::Spec::Macros
  Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)
end
