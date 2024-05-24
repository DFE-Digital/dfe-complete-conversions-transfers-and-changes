require "rails_helper"

RSpec.describe Conversions::ProjectsController do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "academies API behaviour" do
    context "when the API times out" do
      before { mock_timeout_api_responses(urn: 123456, ukprn: 10061021) }

      it "renders the API time out page" do
        post conversions_path, params: {conversion_create_project_form: {urn: "123456"}}

        expect(response).to render_template("pages/academies_api_client_timeout")
      end
    end

    context "when the API is not authenticated" do
      before { mock_unauthorised_api_responses(urn: 123456, ukprn: 10061021) }

      it "renders the API not authorised page" do
        post conversions_path, params: {conversion_create_project_form: {urn: "123456"}}

        expect(response).to render_template("pages/academies_api_client_unauthorised")
      end
    end
  end

  describe "creating a conversion project for an existing trust" do
    context "when the attributes are invalid" do
      it "renders the new form view" do
        post conversions_path, params: {conversion_create_project_form: {urn: "123456"}}

        expect(response).to render_template(:new)
      end

      describe "project user assignment" do
        context "when the project is not being handed over" do
          it "renders the new project show view" do
            params = valid_params_existing_trust
            params["conversion_create_project_form"]["assigned_to_regional_caseworker_team"] = "false"

            post conversions_path, params: params

            expect(response).to redirect_to(project_path(Project.last))
          end
        end
        context "when the project is being handed over" do
          it "renders the what next view" do
            params = valid_params_existing_trust
            params["conversion_create_project_form"]["assigned_to_regional_caseworker_team"] = "true"

            post conversions_path, params: params

            expect(response).to render_template("created")
          end
        end
      end
    end
  end

  describe "creating a conversion project to form a new trust" do
    context "when the attributes are invalid" do
      it "renders the new form view" do
        post conversions_create_mat_path, params: {conversion_create_project_form: {urn: "123456"}}

        expect(response).to render_template(:new_mat)
      end

      describe "project user assignment" do
        context "when the project is not being handed over" do
          it "renders the new project show view" do
            params = valid_params_form_a_mat
            params["conversion_create_project_form"]["assigned_to_regional_caseworker_team"] = "false"

            post conversions_create_mat_path, params: params

            expect(response).to redirect_to(project_path(Project.last))
          end
        end
        context "when the project is being handed over" do
          it "renders the what next view" do
            params = valid_params_form_a_mat
            params["conversion_create_project_form"]["assigned_to_regional_caseworker_team"] = "true"

            post conversions_create_mat_path, params: params

            expect(response).to render_template("created")
          end
        end
      end
    end
  end

  describe "updating an existing project" do
    context "when the attributes are valid" do
      it "renders the project view" do
        project = create(:conversion_project, assigned_to: user)

        post conversions_update_path(project), params: {conversion_edit_project_form: {incoming_trust_ukprn: "10061021"}}

        expect(response).to redirect_to(project_information_path(project))
      end
    end
    context "when the attributes are invalid" do
      it "renders the new form view" do
        project = create(:conversion_project, assigned_to: user)

        post conversions_update_path(project), params: {conversion_edit_project_form: {incoming_trust_ukprn: ""}}

        expect(response).to render_template(:edit)
      end
    end
  end

  def valid_params_existing_trust
    provisional_conversion_date = Date.today.at_beginning_of_month + 1.year
    advisory_board_date = Date.yesterday

    {conversion_create_project_form: {
      urn: "123456",
      incoming_trust_ukprn: "10061021",
      "provisional_conversion_date(3i)": provisional_conversion_date.day.to_s,
      "provisional_conversion_date(2i)": provisional_conversion_date.month.to_s,
      "provisional_conversion_date(1i)": provisional_conversion_date.year.to_s,
      "advisory_board_date(3i)": advisory_board_date.day.to_s,
      "advisory_board_date(2i)": advisory_board_date.month.to_s,
      "advisory_board_date(1i)": advisory_board_date.year.to_s,
      advisory_board_conditions: "",
      directive_academy_order: "false",
      two_requires_improvement: "false",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      handover_note_body: "Handover notes.",
      assigned_to_regional_caseworker_team: "true"
    }}.with_indifferent_access
  end

  def valid_params_form_a_mat
    params = valid_params_existing_trust.except(:incoming_trust_ukprn)
    params[:conversion_create_project_form][:new_trust_name] = "Brand new trust"
    params[:conversion_create_project_form][:new_trust_reference_number] = "TR12345"
    params.with_indifferent_access
  end
end
