require "rails_helper"

RSpec.describe Conversions::Voluntary::ProjectsController do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    establishment = build(:academies_api_establishment, name: "Converting School")
    trust = build(:academies_api_trust, original_name: "Convertor trust")

    mock_successful_api_calls(establishment: establishment, trust: trust)
    sign_in_with(user)
  end

  describe "#index" do
    it "lists voluntary conversion projects" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: user)
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 654321, regional_delivery_officer: user)

      get conversions_voluntary_path

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
      expect(response.body).not_to include(involuntary_conversion_project.urn.to_s)
    end
  end

  describe "#show" do
    it "shows a single voluntary conversion project" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: user)

      get conversions_voluntary_project_path(voluntary_conversion_project)

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
    end

    it "returns 404 if the project is involuntary" do
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 654321, regional_delivery_officer: user)

      get conversions_voluntary_project_path(involuntary_conversion_project)

      expect(response).to have_http_status(:not_found)
    end
  end
end
