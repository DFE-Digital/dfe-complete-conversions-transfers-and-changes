require "rails_helper"

RSpec.describe Conversions::Involuntary::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversions_involuntary_projects_path }
  let(:form_class) { Conversion::Involuntary::CreateProjectForm }
  let(:project_form) { build(:create_involuntary_project_form) }
  let(:project_form_params_key) { "conversion_involuntary_create_project_form" }
  let(:project_form_params) {
    attributes_for(:create_involuntary_project_form,
      "provisional_conversion_date(3i)": "1",
      "provisional_conversion_date(2i)": "1",
      "provisional_conversion_date(1i)": "2030",
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil,
      sponsor_trust_required: "false")
  }

  before do
    establishment = build(:academies_api_establishment)
    trust = build(:academies_api_trust)

    mock_successful_api_calls(establishment: establishment, trust: trust)
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"

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
      follow_redirect!

      expect(response.body).to include(involuntary_conversion_project.urn.to_s)
    end

    it "returns 404 if the project is involuntary" do
      voluntary_conversion_project = create(:voluntary_conversion_project, urn: 654321, regional_delivery_officer: regional_delivery_officer)

      get conversions_involuntary_project_path(voluntary_conversion_project)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "after creating a new project" do
    it "redirects to the project page" do
      post conversions_involuntary_projects_path, params: {"#{project_form_params_key}": {**project_form_params}}

      expect(response).to redirect_to conversions_involuntary_project_path(Project.last)
    end
  end
end
