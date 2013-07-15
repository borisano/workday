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

          worker = Worker.new(
            employee_id: worker_data[:worker_id],
            first_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:first_name],
            last_name: worker_data[:personal_data][:name_data][:legal_name_data][:name_detail_data][:last_name],
            hire_date: worker_data[:employment_data][:worker_status_data][:hire_date] )
          worker.emails = emails_from_data worker_data

          workers << worker
        end
      end

      workers
    end

    def emails_from_data worker_data
      emails = {}
      data = worker_data[:personal_data][:contact_data][:email_address_data]

      # If there is only one email address, data will just be a Hash.
      # If there is more than one email address, data will be an array of Hashes.
      if data.is_a? Array
        data.each do |email_data|
          type = email_data[:usage_data][:type_data][:type_reference][:id][1]
          emails[type] = Email.new type: type, email: email_data[:email_address]
        end
      else
        type = data[:usage_data][:type_data][:type_reference][:id][1]
        emails[type] = Email.new type: type, email: data[:email_address]
      end

      emails
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