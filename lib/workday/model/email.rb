module Workday
  class Email
    include Virtus::ValueObject

    attribute :type, String
    attribute :email, String

    # Returns a Hash of Email objects parsed from the given Workday response
    def self.new_from_email_address_data response
      emails = {}

      # The Workday response will have either a single Email_Address_Data element
      # or an Array of Email_Address_Data elements
      if response.is_a? Array
        response.each do |email_data|
          type = email_data[:usage_data][:type_data][:type_reference][:id][1]
          emails[type] = Email.new type: type, email: email_data[:email_address]
        end
      else
        type = response[:usage_data][:type_data][:type_reference][:id][1]
        emails[type] = Email.new type: type, email: response[:email_address]
      end

      emails
    end
  end
end