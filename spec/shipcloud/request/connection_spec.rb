require "spec_helper"

describe Shipcloud::Request::Connection do
  describe "#setup_https" do
    it "creates a https object" do
      connection = Shipcloud::Request::Connection.new(nil)

      connection.setup_https

      connection.https.should_not be_nil
    end
  end

  describe "#request" do
    it "performs the actual request" do
      connection = Shipcloud::Request::Connection.new(nil)
      connection.setup_https
      connection.stub(:https_request)

      connection.https.should_receive(:request)

      connection.request
    end
  end
end
