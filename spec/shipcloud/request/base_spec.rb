require "spec_helper"

describe Shipcloud::Request::Base do
  context "#perform" do
    it "checks for an api key" do
      allow(Shipcloud).to receive(:api_key).and_return(nil)

      expect{
        Shipcloud::Request::Base.new(nil).perform
      }.to raise_error Shipcloud::AuthenticationError
    end

    it "performs an https request and returns a response hash" do
      allow(Shipcloud).to receive(:api_key).and_return("some key")
      connection = double
      expect(Shipcloud::Request::Connection).to receive(:new).and_return(connection)
      expect(connection).to receive(:setup_https)
      response = double(code: "200", body: { id: 1 }.to_json)
      expect(connection).to receive(:request).and_return(response)

      data = Shipcloud::Request::Base.new(nil).perform
      expect(data).to eq("id" => 1)
    end

    it "performs an https request and raises an Shipcloud::ClientError if the response "\
       "has a 400 status code" do
      allow(Shipcloud).to receive(:api_key).and_return("some key")
      connection = double
      expect(Shipcloud::Request::Connection).to receive(:new).and_return(connection)
      expect(connection).to receive(:setup_https)
      response = double(code: "400", body: { id: 1 }.to_json)
      expect(connection).to receive(:request).and_return(response)

      expect { Shipcloud::Request::Base.new(nil).perform }.to raise_error(Shipcloud::ClientError)
    end

    it "performs an https request and raises an Shipcloud::ServerError if the response "\
       "has a 500 status code" do
      allow(Shipcloud).to receive(:api_key).and_return("some key")
      connection = double
      expect(Shipcloud::Request::Connection).to receive(:new).and_return(connection)
      expect(connection).to receive(:setup_https)
      response = double(code: "500", body: { id: 1 }.to_json)
      expect(connection).to receive(:request).and_return(response)

      expect { Shipcloud::Request::Base.new(nil).perform }.to raise_error(Shipcloud::ServerError)
    end

    it "performs an https request and raises an Shipcloud::ShipcloudError if the body of the "\
       "response is not in JSON" do
      allow(Shipcloud).to receive(:api_key).and_return("some key")
      connection = double
      expect(Shipcloud::Request::Connection).to receive(:new).and_return(connection)
      expect(connection).to receive(:setup_https)
      response = double(code: "200", body: "no json")
      expect(connection).to receive(:request).and_return(response)

      expect { Shipcloud::Request::Base.new(nil).perform }.to raise_error(Shipcloud::ShipcloudError)
    end
  end
end
