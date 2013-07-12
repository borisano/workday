require 'spec_helper'

describe Workday::Phone do

  %w( type number ).each do |attribute|
    it{ should have_attribute attribute }
  end

end