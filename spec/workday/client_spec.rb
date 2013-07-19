require 'spec_helper'

require 'webmock/rspec'

describe Workday::Client do

  let(:url){ 'https://i-0af1d538.workdaysuv.com/ccx/service/gms/Human_Resources/v19' }
  let(:headers){ {'Content-Type' => 'application/xml'} }
  let(:single_response_100){ File.read('spec/fixtures/get_workers/single_response_100.xml') }
  let(:paged_response_1){ File.read('spec/fixtures/get_workers/paged_response_1.xml') }
  let(:paged_response_2){ File.read('spec/fixtures/get_workers/paged_response_2.xml') }

  let(:client){ Workday::Client.new('user_name', 'password') }
  subject{client}


  it{ should be }
  describe "#initialize" do
    it "assigns a client" do
      subject.instance_variable_get(:@client).should be
    end

    it "assigns a logger" do
      subject.instance_variable_get(:@logger).should be
    end

    it "assigns a given logger" do
      logger = ::Logger.new STDERR
      client = Workday::Client.new 'user_name', 'password', logger: logger
      client.instance_variable_get(:@logger).should eq logger
    end
  end

  it{ should respond_to :get_workers }
  describe "#get_workers" do
    it "parses sample XML return successfully" do
      stub_request(:post, url).to_return(body: single_response_100, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 100
    end

    it "handles multi-page responses" do
      stub_request(:post, url).with(body: /Page>1/).to_return(body: paged_response_1, headers: headers)
      stub_request(:post, url).with(body: /Page>2/).to_return(body: paged_response_2, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 3
    end
  end

  it{ should respond_to :workers_from_response }
  describe "#workers_from_response" do
    it "parses the response into workers" do
      stub_request(:post, url).to_return(body: single_response_100, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 100
    end
  end

  describe 'errors' do
    it "handles errors" do
      Logger.any_instance.expects(:error).at_least_once
      Worker.expects(:new_from_worker_data).raises(StandardError, 'Testing Errors').at_least_once
      stub_request(:post, url).to_return(body: single_response_100, headers: headers)
      workers = subject.get_workers
      workers.should_not be_nil
    end
  end

end