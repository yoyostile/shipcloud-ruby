require "spec_helper"

describe Shipcloud::Request::Base do
  context "#perform" do
    it "checks for an api key" do
      Shipcloud.stub(:api_key).and_return(nil)

      expect{
        Shipcloud::Request::Base.new(nil).perform
      }.to raise_error Shipcloud::AuthenticationError
    end

    it "performs an https request" do
      allow(Shipcloud).to receive(:api_key).and_return("some key")
      connection = double("connection", setup_https: nil, request: nil)
      validator = double("validator", validated_data_for: nil)
      allow(Shipcloud::Request::Connection).to receive(:new).and_return(connection)
      allow(Shipcloud::Request::Validator).to receive(:new).and_return(validator)

      Shipcloud::Request::Base.new(nil).perform

      expect(connection).to have_received(:setup_https)
      expect(connection).to have_received(:request)
      expect(validator).to have_received(:validated_data_for)
    end
  end
end
