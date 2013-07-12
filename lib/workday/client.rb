module Workday
  class Client
    def initialize user_name, password
      @client = Savon.client( initialize_params user_name, password )
    end

    private

    def initialize_params user_name, password
      {
        wsdl: 'lib/workday/assets/human_resources_v19.wsdl',
        wsse_auth: [user_name, password],
        namespaces: {'xmlns:bsvc' => 'urn:com.workday/bsvc'},
        namespace_identifier: :bsvc,
        log_level: :error,
        pretty_print_xml: true
      }
    end

  end
end