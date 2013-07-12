require 'spec_helper'

describe Workday::Address do

  %w( type lines city state postal_code country ).each do |attribute|
    it{ should respond_to attribute }
  end

end