require 'savon'

module Workday
  class Client
    def initialize user_name, password
      @client = Savon.client( initialize_params user_name, password )
    end

    def get_workers
      workers_from_response get_workers_call(page: 1)
    end

    def workers_from_response response
      workers = []

      if response
        worker_list = Workday.response_to_array response.body[:get_workers_response][:response_data][:worker]
        worker_list.each do |worker|
          begin
            workers << Worker.new_from_worker_data(worker[:worker_data])
          rescue StandardError => e
            Logger.error "Unable to process worker record:  #{e}\n#{worker}"
          end
        end

        # Recurse if more pages in the results
        page = response.body[:get_workers_response][:response_results][:page]
        total_pages = response.body[:get_workers_response][:response_results][:total_pages]
        if page < total_pages
          workers << workers_from_response(get_workers_call(page: page.to_i + 1))
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

    def get_workers_params params = {}
      {
        message_tag: :Get_Workers_Request,
        message: {
          "bsvc:Response_Filter" => {
            "Page" => params[:page] ? params[:page] : 1 },
          "bsvc:Response_Group" => {
            "Include_Personal_Information" => true,
            "Include_Employment_Information" => true } },
        attributes: { "bsvc:version" => "v19" }
      }
    end

    def get_workers_call params = {}
      @client.call :get_workers, get_workers_params(params)
    end
  end
end