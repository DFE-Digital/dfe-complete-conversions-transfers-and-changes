require "rails_helper"

RSpec.describe Conversions::Voluntary::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversions_voluntary_projects_path }
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
      regional_delivery_officer: nil,
      directive_academy_order: "false")
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

      get conversions_voluntary_path

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
    end
  end

  describe "#show" do
    it "shows a single voluntary conversion project" do
      voluntary_conversion_project = create(:conversion_project, urn: 123456, regional_delivery_officer: regional_delivery_officer)

      get project_path(voluntary_conversion_project)
      follow_redirect!

      expect(response.body).to include(voluntary_conversion_project.urn.to_s)
    end
  end

  describe "after creating a new project" do
    it "redirects to the project page" do
      post conversions_voluntary_projects_path, params: {"#{project_form_params_key}": {**project_form_params}}

      expect(response).to redirect_to project_path(Project.last)
    end
  end
end
