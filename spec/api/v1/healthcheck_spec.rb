require "rails_helper"

RSpec.describe V1::Healthcheck do
  context "when the db connection is up" do
    before { allow(Ops::DbAvailability).to receive(:db_available?).and_return(true) }

    it "returns 'Healthy'" do
      get "/api/v1/healthcheck"
      expect(response.body).to eq("Healthy")
    end
  end

  context "when the db connection is NOT up" do
    before { allow(Ops::DbAvailability).to receive(:db_available?).and_return(false) }

    it "returns 'Unhealthy'" do
      get "/api/v1/healthcheck"
      expect(response.body).to eq("Unhealthy")
    end
  end
end
