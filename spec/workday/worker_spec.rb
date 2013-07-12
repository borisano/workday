require 'spec_helper'

describe Workday::Worker do

  %w( employee_id first_name last_name hire_date ).each do |attribute|
    it{ should respond_to attribute }
  end

end