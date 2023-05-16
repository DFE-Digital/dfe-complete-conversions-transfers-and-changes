require "rails_helper"

RSpec.describe Conversions::ProjectsController do
  let(:user) { create(:user, :caseworker) }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:form_class) { Conversion::CreateProjectForm }
  let(:project_form) { build(:create_project_form) }
  let(:project_form_params) {
    attributes_for(:create_project_form,
      "provisional_conversion_date(3i)": "1",
      "provisional_conversion_date(2i)": "1",
      "provisional_conversion_date(1i)": "2030",
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil,
      directive_academy_order: "false")
  }

  describe "#index" do
    before do
      establishment = build(:academies_api_establishment, name: "Converting School")
      trust = build(:academies_api_trust, original_name: "Convertor trust")

      mock_successful_api_calls(establishment: establishment, trust: trust)
      sign_in_with(user)
    end

    it "lists conversion projects" do
      conversion_project = create(:conversion_project, caseworker: user)

      get conversions_path

      expect(response.body).to include(conversion_project.establishment.name)
    end
  end

  describe "#create" do
    let(:project) { build(:conversion_project) }
    let!(:team_leader) { create(:user, :team_leader) }

    before do
      establishment = build(:academies_api_establishment, name: "Converting School")
      trust = build(:academies_api_trust, original_name: "Convertor trust")

      mock_successful_api_calls(establishment: establishment, trust: trust)
      sign_in_with(regional_delivery_officer)
    end

    subject(:perform_request) do
      post conversions_path, params: {conversion_create_project_form: {**project_form_params}}
      response
    end

    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    context "when the project is not valid" do
      before do
        allow(form_class).to receive(:new).and_return(project_form)
        allow(project_form).to receive(:valid?).and_return false
      end

      it "re-renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the project is valid" do
      let(:new_project_record) { Project.last }

      before do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)

        perform_request
      end

      it "assigns the regional delivery officer" do
        expect(new_project_record.regional_delivery_officer).to eq regional_delivery_officer
      end

      it "creates a new project and note" do
        expect(Project.count).to be 1
        expect(Note.count).to be 1
        expect(Note.last.user).to eq regional_delivery_officer
      end

      context "when the note body is empty" do
        subject(:perform_request) do
          post conversions_path, params: {conversion_create_project_form: {**project_form_params, note_body: ""}}

          response
        end

        it "does not create a new note" do
          expect(Note.count).to be 0
        end
      end
    end

    context "when the Academies API times out" do
      before do
        mock_timeout_api_responses(urn: 123456, ukprn: 10061021)
      end

      it "redirects to an informational client timeout page" do
        expect(perform_request).to render_template("pages/academies_api_client_timeout")
      end
    end

    context "when the Academies API returns an unauthorised error" do
      before do
        mock_unauthorised_api_responses(urn: 123456, ukprn: 10061021)
      end

      it "redirects to an informational client unauthorised page" do
        expect(perform_request).to render_template("pages/academies_api_client_unauthorised")
      end
    end

    context "when the creating user is not a regional delivery officer" do
      let(:caseworker) { create(:user, :caseworker) }

      before do
        sign_in_with(caseworker)
      end

      it "does not create the project and shows an error message" do
        perform_request
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end
  end

  describe "after a project is created" do
    before do
      mock_all_academies_api_responses
      sign_in_with(regional_delivery_officer)
    end

    context "when the project is not assigned to regional casework services" do
      before { project_form_params["assigned_to_regional_caseworker_team"] = "false" }

      it "redirects to the project view" do
        post conversions_path, params: {conversion_create_project_form: {**project_form_params}}

        expect(response).to redirect_to project_path(Project.last)
      end

      it "assigns the regional delivery officer" do
        post conversions_path, params: {conversion_create_project_form: {**project_form_params}}

        project = Project.last
        expect(project.assigned_to).to eql regional_delivery_officer
      end
    end

    context "when the project is assigned to regional casework services" do
      before { project_form_params["assigned_to_regional_caseworker_team"] = "true" }

      it "renders the created view" do
        post conversions_path, params: {conversion_create_project_form: {**project_form_params}}

        expect(response).to render_template("created")
      end

      it "does not assign the regional delivery officer" do
        post conversions_path, params: {conversion_create_project_form: {**project_form_params}}

        project = Project.last
        expect(project.assigned_to).to be_nil
      end
    end
  end
end
