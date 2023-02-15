require "rails_helper"

RSpec.describe HealthcheckController, type: :request do
  describe "#check" do
    it "returns status 200" do
      get healthcheck_path

      expect(response).to have_http_status(200)
    end
  end
end
