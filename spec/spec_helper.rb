require 'simplecov'
SimpleCov.start

require 'workday'
include Workday

require 'virtus-rspec'


RSpec.configure do |config|
  config.order = "random"

  config.include Virtus::Matchers
end
