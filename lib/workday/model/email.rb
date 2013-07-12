module Workday
  class Email
    include Virtus::ValueObject

    attribute :type, String
    attribute :email, String
  end
end