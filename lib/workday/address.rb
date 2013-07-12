module Workday
  class Address
    include Virtus

    attribute :type, String
    attribute :lines, Array[String]
    attribute :city, String
    attribute :state, String
    attribute :postal_code, String
    attribute :country, String
  end
end