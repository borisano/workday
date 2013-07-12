module Workday
  class Email
    include Virtus

    attribute :type, String
    attribute :email, String
  end
end