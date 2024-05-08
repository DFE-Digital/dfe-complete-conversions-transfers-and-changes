require "rails_helper"

RSpec.describe V1::Healthcheck do
  it "returns OK" do
    get "/api/healthcheck"
    expect(response.body).to eq({status: "OK"}.to_json)
  end
end
