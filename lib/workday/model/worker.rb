module Workday
  class Worker
    include Virtus::ValueObject

    attribute :employee_id, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :hire_date, Date

    attribute :addresses, Set[Address]
    attribute :email, Email
  end
end
