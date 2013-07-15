require 'spec_helper'

describe Workday::Worker do

  %w( employee_id first_name last_name hire_date addresses phones emails ).each do |attribute|
    it{ should have_attribute attribute }
  end

  describe ".new_from_worker_data" do

    let(:expected_worker){
      Workday::Worker.new(
        employee_id: '21001',
        first_name: 'Logan',
        last_name: 'McNeil',
        hire_date: '2000-01-01-08:00'
    ) }

    let(:worker_data){
      {
        :worker_id => "21001",
        :personal_data => {
          :name_data => {
            :legal_name_data => {
              :name_detail_data => {
                :first_name => "Logan",
                :last_name => "McNeil"
              }
            }
          }
        },
        :employment_data => {
          :worker_status_data => {
            :hire_date => Date.parse("2000-01-01-08:00")
          }
        }
      }
    }

    it "returns a Worker" do
      worker = Workday::Worker.new_from_worker_data worker_data

      # When Virtus releases a fix for ValueObjects with Hashes, the follow can
      # be replaced with the simple "should eq" test
      # worker.should eq expected_worker

      worker.employee_id.should eq expected_worker.employee_id
      worker.first_name.should eq expected_worker.first_name
      worker.last_name.should eq expected_worker.last_name
      worker.hire_date.should eq expected_worker.hire_date
    end
  end
end