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

    def self.new_from_worker_data worker_data
      Worker.new(
        employee_id: worker_data[:worker_id],
        first_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:first_name],
        last_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:last_name],
        hire_date: worker_data[:employment_data][:worker_status_data][:hire_date] )
    end
  end
end
