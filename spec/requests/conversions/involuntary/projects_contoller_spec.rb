require "rails_helper"

RSpec.describe Conversions::Involuntary::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    establishment = build(:academies_api_establishment)
    trust = build(:academies_api_trust)

    mock_successful_api_calls(establishment: establishment, trust: trust)
    sign_in_with(regional_delivery_officer)
  end

  describe "#index" do
    it "lists involuntary conversion projects" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: regional_delivery_officer)
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 654321, regional_delivery_officer: regional_delivery_officer)

      get conversions_involuntary_path

      expect(response.body).to include(involuntary_conversion_project.urn.to_s)
      expect(response.body).not_to include(voluntary_conversion_project.urn.to_s)
    end
  end

  describe "#show" do
    it "shows a single involuntary conversion project" do
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 123456, regional_delivery_officer: regional_delivery_officer)

      get conversions_involuntary_project_path(involuntary_conversion_project)

      expect(response.body).to include(involuntary_conversion_project.urn.to_s)
    end

    it "returns 404 if the project is involuntary" do
      voluntary_conversion_project = create(:voluntary_conversion_project, urn: 654321, regional_delivery_officer: regional_delivery_officer)

      get conversions_involuntary_project_path(voluntary_conversion_project)

      expect(response).to have_http_status(:not_found)
    end
  end
end
