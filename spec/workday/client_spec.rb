require 'spec_helper'

describe Workday::Client do

  let(:client){ Workday::Client.new('foo', 'bar') }
  subject{client}

  it{ should be }
  describe "#initialize" do
    it "assigns a client" do
      client.instance_variable_get(:@client).should be
    end
  end

end