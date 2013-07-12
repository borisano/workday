require 'virtus'

module Workday
  autoload :Client, 'workday/client'

  autoload :Worker, 'workday/model/worker'
  autoload :Address, 'workday/model/address'
  autoload :Phone, 'workday/model/phone'
  autoload :Email, 'workday/model/email'
end

