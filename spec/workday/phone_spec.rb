require 'spec_helper'

describe Workday::Phone do

  %w( type number ).each do |attribute|
    it{ should respond_to attribute }
  end

end