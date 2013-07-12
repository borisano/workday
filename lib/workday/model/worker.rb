module Workday
  class Worker
    include Virtus
    # include Virtus::ValueObject  -- Bug in 0.5.5 that prevents ValueObject from using Hash coercion; use when fixed

    attribute :employee_id, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :hire_date, Date

    attribute :addresses, Hash[Symbol => Address]
    attribute :phones, Hash[Symbol => Phone]
    attribute :emails, Hash[Symbol => Email]
  end
end
