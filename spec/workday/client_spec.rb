require 'spec_helper'

require 'webmock/rspec'

describe Workday::Client do

  let(:url){ 'https://i-0af1d538.workdaysuv.com/ccx/service/gms/Human_Resources/v19' }
  let(:headers){ {'Content-Type' => 'application/xml'} }
  let(:test_worker_response){ File.read('spec/fixtures/get_workers_response.xml') }

  let(:expected_worker){
    Workday::Worker.new(
      employee_id: '21001',
      first_name: 'Logan',
      last_name: 'McNeil',
      hire_date: '2000-01-01-08:00',
      emails: {
        'HOME' => { type: 'HOME', email: 'clay.christensen@workday.com' },
        'WORK' => { type: 'WORK', email: 'clay.christensen@workday.com' } }
  ) }

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
    it "can retrieve a worker" do
      stub_request(:post, url).to_return(body: test_worker_response, headers: headers)
      workers = subject.get_workers
      workers.size.should eq 100

      # When Virtus releases a fix for ValueObjects with Hashes, these can go
      # away and be replaced with a simple "should eq" test
      worker = workers.first
      worker.employee_id.should eq expected_worker.employee_id
      worker.first_name.should eq expected_worker.first_name
      worker.last_name.should eq expected_worker.last_name
      worker.hire_date.should eq expected_worker.hire_date
      worker.emails.should eq expected_worker.emails
    end
  end
end