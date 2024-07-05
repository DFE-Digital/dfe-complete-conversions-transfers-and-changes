require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(user)
  end

  describe "#create" do
    let(:user) { create(:user, :caseworker) }
    it "returns 404 not found if the passed project type is unknown" do
      post projects_path(params: {new_project_form: {project_type: "unknown"}})

      expect(response).to render_template "pages/page_not_found"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#show" do
    let(:user) { create(:user, :team_leader) }

    it "redirects to a 404 page when a project cannot be found" do
      project = create(:conversion_project)
      allow(Project).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get project_path(project)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#index" do
    let(:user) { create(:user, :caseworker) }

    it "redirects to the in progress projects path" do
      get projects_path
      expect(response).to redirect_to(in_progress_your_projects_path)
    end
  end

  describe "#confirm_destroy" do
    context "with a non-service support user" do
      let(:user) { create(:regional_casework_services_user) }

      it "returns unauthorised" do
        project = create(:conversion_project)

        get confirm_delete_project_path(project)
        expect(response).not_to render_template(:confirm_delete)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "with a service support user" do
      let(:user) { create(:service_support_user) }

      it "returns success" do
        project = create(:conversion_project)

        get confirm_delete_project_path(project)
        expect(response).to render_template(:confirm_delete)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
