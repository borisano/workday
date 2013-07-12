module Workday
  class Phone
    include Virtus::ValueObject

    attribute :type, String
    attribute :number, String
  end
end