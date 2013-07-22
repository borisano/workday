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

    def get_workers params = {}
      workers = do_get_workers params
      @logger.debug("Workday:  Retreieved #{workers.size} workers from response.")
      workers
    end

    private

    def do_get_workers params = {}
      workers = []

      # For multi-page responses, the As_Of_Entry_DateTime anchors the pages
      params[:page] = 1 if !params[:page]
      params[:as_of_entry_datetime] = DateTime.now if !params[:as_of_entry_datetime]

      response = get_workers_call params
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
          params[:page] = params[:page] + 1
          workers << do_get_workers(params)
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

    def get_workers_call params = {}
      @logger.debug "Workday:  Sending Get_Workers request.  Params = #{params}"
      @client.call :get_workers, get_workers_params(params)
    end

    def get_workers_params params = {}
      {
        message_tag: :Get_Workers_Request,
        message: get_workers_message(params),
        attributes: { "bsvc:version" => "v19" }
      }
    end

    def get_workers_message params = {}
      message = {}
      message.merge! get_response_filter(params)
      message.merge! get_response_group
      message
    end

    def get_response_filter params = {}
      filter = {}

      filter["Page"] = params[:page] if params[:page]
      filter["Count"] = params[:count] if params[:count]
      filter["As_Of_Effective_Date"] = params[:as_of_effective_date] if params[:as_of_effective_date]
      filter["As_Of_Entry_DateTime"] = params[:as_of_entry_datetime] if params[:as_of_entry_datetime]

      { "bsvc:Response_Filter" => filter }
    end

    def get_response_group
      { "bsvc:Response_Group" => {
        "Include_Personal_Information" => true,
        "Include_Employment_Information" => true } }
    end

  end
end