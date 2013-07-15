require 'savon'

module Workday
  class Client
    def initialize user_name, password
      @client = Savon.client( initialize_params user_name, password )
    end

    def get_workers
      response = @client.call :get_workers, get_workers_params
      workers_from_response response
    end

    private

    def workers_from_response response
      workers = []

      if response
        response.body[:get_workers_response][:response_data][:worker].each do |worker|
          worker_data = worker[:worker_data]

          worker = Worker.new_from_worker_data worker_data
          worker.emails = Email.new_from_email_address_data worker_data[:personal_data][:contact_data][:email_address_data]

          workers << worker
        end
      end

      workers
    end

    def addresses_from_data worker_data
    end

    def initialize_params user_name, password
      {
        wsdl: File.expand_path('lib/workday/assets/human_resources_v19.wsdl'),
        wsse_auth: [user_name, password],
        namespaces: {'xmlns:bsvc' => 'urn:com.workday/bsvc'},
        namespace_identifier: :bsvc,
        log_level: :error,
        pretty_print_xml: true
      }
    end

    def get_workers_params
      {
        message_tag: :Get_Workers_Request,
        message: {
          "bsvc:Response_Group" => {
            "Include_Personal_Information" => true,
            "Include_Employment_Information" => true } },
        attributes: { "bsvc:version" => "v19" }
      }
    end
  end
end