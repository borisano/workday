require 'simplecov'
SimpleCov.start

require 'workday'
include Workday

require 'savon_spec'
require 'virtus-rspec'


RSpec.configure do |config|
  config.order = "random"

  config.include Savon::Spec::Macros

  config.include Virtus::Matchers
end
