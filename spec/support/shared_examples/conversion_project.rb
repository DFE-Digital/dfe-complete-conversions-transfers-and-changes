require "rails_helper"

RSpec.shared_examples "a conversion project" do
  describe "#create" do
    let(:project) { build(:conversion_project) }
    let!(:team_leader) { create(:user, :team_leader) }

    subject(:perform_request) do
      post create_path, params: {"#{project_form_params_key}": {**project_form_params}}
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
          post create_path, params: {"#{project_form_params_key}": {**project_form_params, note_body: ""}}
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
end
