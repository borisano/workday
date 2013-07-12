require 'spec_helper'

describe Workday::Email do

  %w( type email ).each do |attribute|
    it{ should respond_to attribute }
  end

end