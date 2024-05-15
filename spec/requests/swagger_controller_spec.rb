require "rails_helper"

RSpec.describe "swagger controller" do
  describe "#show" do
    it "is public" do
      get "/api/docs"

      expect(response).to have_http_status :success
    end

    it "renders the show template" do
      get "/api/docs"

      expect(response).to render_template :show
    end
  end
end
