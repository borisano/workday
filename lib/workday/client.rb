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

    def workers_from_response response
      workers = []

      if response
        response.body[:get_workers_response][:response_data][:worker].each do |worker|
          begin
            workers << Worker.new_from_worker_data(worker[:worker_data])
          rescue StandardError => e
            Logger.error "Unable to process worker record:  #{e}\n#{worker}"
          end
        end
      end

      workers
    end

    private

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