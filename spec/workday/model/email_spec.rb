require 'spec_helper'

describe Workday::Email do

  %w( type email ).each do |attribute|
    it{ should have_attribute attribute }
  end

end