require "rails_helper"

RSpec.describe V1::Auth do
  context "when there is a valid api key in the header" do
    it "returns OK" do
      _api_key = ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow)
      get "/api/auth", headers: {Apikey: "testkey"}
      expect(response.body).to eq({status: "OK"}.to_json)
    end
  end

  context "when there is no api key in the header" do
    it "returns unauthorised" do
      get "/api/auth"
      expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
    end
  end

  context "when there is an invalid api key in the header" do
    it "returns unauthorised" do
      get "/api/auth", headers: {Apikey: "somethingelse"}
      expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
    end
  end

  context "when there is an expired api key in the header" do
    it "returns unauthorised" do
      _api_key = ApiKey.create(api_key: "testkey", expires_at: Date.yesterday)
      get "/api/auth", headers: {Apikey: "testkey"}
      expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
    end
  end
end
