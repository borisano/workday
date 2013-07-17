require 'virtus'

module Workday
  autoload :Client, 'workday/client'

  autoload :Worker, 'workday/model/worker'
  autoload :Address, 'workday/model/address'
  autoload :Phone, 'workday/model/phone'
  autoload :Email, 'workday/model/email'

  # If the SOAP response has more than one element, it'll be an Array.
  # If it has just one element, then it will not be an Array.
  # This method will take either case and will always return an Array.
  def self.response_to_array response
    if response.is_a? Array
      return response
    else
      return Array.new << response
    end
  end
end

