module Workday
  class Phone
    include Virtus::ValueObject

    attribute :type, String
    attribute :number, String

    # Returns a Hash of Phone objects parsed from the given Workday response
    def self.new_from_phone_data response
      phones = {}

      # The Workday response will have either a single Phone_Data element
      # or an Array of Phone_Data elements
      if response.is_a? Array
        response.each do |phone_data|
          phone = get_phone_from_data phone_data
          phones[phone.type] = phone
        end
      else
        phone = get_phone_from_data response
        phones[phone.type] = phone
      end

      phones
    end

    private

    def self.get_phone_from_data phone_data
      Phone.new(
        type: phone_data[:usage_data][:type_data][:type_reference][:id][1],
        number: phone_data[:"@wd:formatted_phone"]
      )
    end
  end
end