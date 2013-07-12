module Workday
  class Phone
    include Virtus

    attribute :type, String
    attribute :number, String
  end
end