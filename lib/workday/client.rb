require 'logger'
require 'savon'

module Workday
  class Client
    def initialize user_name, password, options = {}
      @client = Savon.client( initialize_params user_name, password )

      if ENV['WORKDAY_DEBUG'] || !options[:logger]
        @logger = ::Logger.new(STDERR)
      else
        @logger = options[:logger]
      end
    end

    def get_workers
      workers_from_response get_workers_call(page: 1)
    end

    def workers_from_response response
      workers = []

      if response
        worker_list = Workday.response_to_array response.body[:get_workers_response][:response_data][:worker]
        page = response.body[:get_workers_response][:response_results][:page]
        total_pages = response.body[:get_workers_response][:response_results][:total_pages]

        @logger.debug("Workday:  Processing page #{page} of #{total_pages} total pages.")
        worker_list.each do |worker|
          begin
            workers << Worker.new_from_worker_data(worker[:worker_data])
          rescue StandardError => e
            @logger.error "Unable to process worker record:  #{e}\n#{worker}"
          end
        end

        # Recurse if more pages in the results
        if page < total_pages
          workers << workers_from_response(get_workers_call(page: page.to_i + 1))
        end
      end

      @logger.debug("Workday:  Retreieved #{workers.size} workers from response.")
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
      @logger.debug "Workday:  Sending Get_Workers request.  Params = #{params}"
      @client.call :get_workers, get_workers_params(params)
    end
  end
end