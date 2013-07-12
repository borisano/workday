require 'simplecov'
SimpleCov.start

require 'workday'

require 'savon_spec'
require 'ostruct'

RSpec.configure do |config|
  config.order = "random"

  config.include Savon::Spec::Macros
end
