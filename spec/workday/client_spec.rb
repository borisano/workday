require 'spec_helper'

require 'webmock/rspec'

describe Workday::Client do

  let(:url){ 'https://i-0af1d538.workdaysuv.com/ccx/service/gms/Human_Resources/v19' }
  let(:headers){ {'Content-Type' => 'application/xml'} }
  let(:test_worker_response){ File.read('spec/fixtures/get_workers_response.xml') }

  let(:client){ Workday::Client.new('user_name', 'password') }
  subject{client}

  it{ should be }
  describe "#initialize" do
    it "assigns a client" do
      subject.instance_variable_get(:@client).should be
    end
  end

  it{ should respond_to :get_workers }
  describe "#get_workers" do
    it "parses sample XML return successfully" do
      stub_request(:post, url).to_return(body: test_worker_response, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 100
    end
  end

  it{ should respond_to :workers_from_response }
  describe "#workers_from_response" do
    it "parses the response into workers" do
      stub_request(:post, url).to_return(body: test_worker_response, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 100
    end

    it "handles errors" do

    end
  end

  describe 'errors' do
    it "handles errors" do
      Logger.expects(:error).at_least_once
      Worker.expects(:new_from_worker_data).raises(StandardError, 'Testing Errors').at_least_once
      stub_request(:post, url).to_return(body: test_worker_response, headers: headers)
      workers = subject.get_workers
      workers.should_not be_nil
    end
  end

end