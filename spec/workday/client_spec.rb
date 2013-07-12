require 'spec_helper'

describe Workday::Client do

  describe "#initialize" do
    it "initializes" do
      client = Workday::Client.new 'foo', 'bar'
      client.should be
    end

    it "assigns a client" do
      client = Workday::Client.new 'foo', 'bar'
      client.instance_variable_get(:@client).should be
    end
  end


end