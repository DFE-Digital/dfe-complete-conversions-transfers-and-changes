require "rails_helper"

RSpec.describe Conversions::Voluntary::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversions_voluntary_projects_path }
  let(:workflow_root) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:form_class) { Conversion::Voluntary::CreateProjectForm }
  let(:project_form) { build(:create_voluntary_project_form) }
  let(:project_form_params_key) { "conversion_voluntary_create_project_form" }
  let(:project_form_params) {
    attributes_for(:create_voluntary_project_form,
      "provisional_conversion_date(3i)": "1",
      "provisional_conversion_date(2i)": "1",
      "provisional_conversion_date(1i)": "2030",
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil)
  }

  before do
    establishment = build(:academies_api_establishment, name: "Converting School")
    trust = build(:academies_api_trust, original_name: "Convertor trust")

    mock_successful_api_calls(establishment: establishment, trust: trust)
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"

  describe "#index" do
    it "lists voluntary conversion projects" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: regional_delivery_officer)
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 654321, regional_delivery_officer: regional_delivery_officer)

      get conversions_voluntary_path

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
      expect(response.body).not_to include(involuntary_conversion_project.urn.to_s)
    end
  end

  describe "#show" do
    it "shows a single voluntary conversion project" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: regional_delivery_officer)

      get conversions_voluntary_project_path(voluntary_conversion_project)
      follow_redirect!

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
    end

    it "returns 404 if the project is involuntary" do
      involuntary_conversion_project = create(:involuntary_conversion_project, urn: 654321, regional_delivery_officer: regional_delivery_officer)

      get conversions_voluntary_project_path(involuntary_conversion_project)

      expect(response).to have_http_status(:not_found)
    end
  end
end
