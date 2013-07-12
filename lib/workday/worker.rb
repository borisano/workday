module Workday
  class Worker
    include Virtus

    attribute :employee_id, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :hire_date, Date
  end
end
