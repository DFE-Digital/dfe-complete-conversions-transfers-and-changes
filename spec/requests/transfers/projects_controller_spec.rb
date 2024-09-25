require "rails_helper"

RSpec.describe Transfers::ProjectsController do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "academies API behaviour" do
    context "when the API times out" do
      before do
        mock_academies_api_establishment_error(urn: 123456)
        mock_academies_api_trust_error(ukprn: 10061021)
      end

      it "renders the API time out page" do
        post transfers_path, params: {transfer_create_project_form: {urn: "123456"}}

        expect(response).to render_template("pages/academies_api_client_timeout")
      end
    end

    context "when the API is not authenticated" do
      before do
        mock_academies_api_establishment_unauthorised(urn: 123456)
        mock_academies_api_trust_unauthorised(ukprn: 10061021)
      end

      it "renders the API not authorised page" do
        post transfers_path, params: {transfer_create_project_form: {urn: "123456"}}

        expect(response).to render_template("pages/academies_api_client_unauthorised")
      end
    end
  end

  describe "creating a transfer project for an existing trust" do
    context "when the attributes are invalid" do
      it "renders the new form view" do
        post transfers_path, params: {transfer_create_project_form: {urn: "123456"}}

        expect(response).to render_template(:new)
      end

      context "when the attributes are valid" do
        it "renders the new project show view" do
          params = valid_params_existing_trust
          params["transfer_create_project_form"]["assigned_to_regional_caseworker_team"] = "false"

          post transfers_path, params: params

          expect(response).to redirect_to(project_path(Project.last))
        end
      end
    end
  end

  describe "creating a transfer  project to form a new trust" do
    context "when the attributes are invalid" do
      it "renders the new form view" do
        post transfers_create_mat_path, params: {transfer_create_project_form: {urn: "123456"}}

        expect(response).to render_template(:new_mat)
      end

      context "when the attributes are valid" do
        it "renders the new project show view" do
          params = valid_params_form_a_mat
          params["transfer_create_project_form"]["assigned_to_regional_caseworker_team"] = "false"

          post transfers_create_mat_path, params: params

          expect(response).to redirect_to(project_path(Project.last))
        end
      end
    end
  end

  describe "updating an existing project" do
    context "when the attributes are valid" do
      it "renders the project view" do
        project = create(:transfer_project, assigned_to: user)

        post transfers_update_path(project), params: {transfer_edit_project_form: {incoming_trust_ukprn: "10061021"}}

        expect(response).to redirect_to(project_information_path(project))
      end
    end
    context "when the attributes are invalid" do
      it "renders the new form view" do
        project = create(:transfer_project, assigned_to: user)

        post transfers_update_path(project), params: {transfer_edit_project_form: {incoming_trust_ukprn: ""}}

        expect(response).to render_template(:edit)
      end
    end
  end

  def valid_params_existing_trust
    provisional_transfer = Date.today.at_beginning_of_month + 1.year
    advisory_board_date = Date.yesterday

    {transfer_create_project_form: {
      urn: "123456",
      incoming_trust_ukprn: "10061021",
      outgoing_trust_ukprn: "10061022",
      "provisional_transfer_date(3i)": provisional_transfer.day.to_s,
      "provisional_transfer_date(2i)": provisional_transfer.month.to_s,
      "provisional_transfer_date(1i)": provisional_transfer.year.to_s,
      "advisory_board_date(3i)": advisory_board_date.day.to_s,
      "advisory_board_date(2i)": advisory_board_date.month.to_s,
      "advisory_board_date(1i)": advisory_board_date.year.to_s,
      advisory_board_conditions: "",
      two_requires_improvement: "false",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/outgoing_trust",
      handover_note_body: "Handover notes.",
      assigned_to_regional_caseworker_team: "true",
      inadequate_ofsted: "false",
      financial_safeguarding_governance_issues: "false",
      outgoing_trust_to_close: "false"
    }}.with_indifferent_access
  end

  def valid_params_form_a_mat
    params = valid_params_existing_trust.except(:incoming_trust_ukprn)
    params[:transfer_create_project_form][:new_trust_name] = "Brand new trust"
    params[:transfer_create_project_form][:new_trust_reference_number] = "TR12345"
    params.with_indifferent_access
  end
end
