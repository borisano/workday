require 'spec_helper'

describe Workday::Worker do

  %w( employee_id first_name last_name hire_date addresses email ).each do |attribute|
    it{ should have_attribute attribute }
  end

end