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
          workers << Worker.new(
            employee_id: worker_data[:worker_id],
            first_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:first_name],
            last_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:last_name],
            hire_date: worker_data[:employment_data][:worker_status_data][:hire_date]
            )
        end
      end

      workers
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

    def worker_employee_id worker
      worker[:worker_data][:worker_id]
    end

  end
end