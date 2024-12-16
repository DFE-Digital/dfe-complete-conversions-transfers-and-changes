require "rails_helper"

RSpec.describe HealthcheckController, type: :request do
  describe "#healthcheck" do
    context "when the database is connected" do
      before { allow(ActiveRecord::Base).to receive(:connected?).and_return(true) }

      it "returns status 200 Healthy" do
        get healthcheck_path

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Healthy")
      end
    end

    context "when the database is NOT connected" do
      before { allow(ActiveRecord::Base).to receive(:connected?).and_return(false) }

      it "returns status 200 Unhealthy" do
        get healthcheck_path

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Unhealthy")
      end
    end
  end
end
