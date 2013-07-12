require 'spec_helper'

describe Workday::Address do

  %w( type address_lines city state postal_code country ).each do |attribute|
    it{ should respond_to attribute }
  end

end