require "rails_helper"

RSpec.describe "Project management" do
  before do
    mock_successful_authentication(user.email)
    allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(user.id)
  end

  describe "creating a new project" do
    context "when the user is a regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }
      it "allows the action and renders the new template" do
        get conversion_voluntary_new_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end

      it "shows the new project button" do
        get projects_path
        expect(response.body).to include("Add a new project")
      end
    end

    context "when a user is a caseworker" do
      let(:user) { create(:user, :caseworker) }

      it "redirects to the root path and displays a not authorized message" do
        get conversion_voluntary_new_path
        expect(response).not_to render_template(:new)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end

      it "does not show the new project button" do
        get projects_path
        expect(response.body).not_to include(I18n.t("project.new.title"))
      end
    end

    context "when the user is a team lead" do
      let(:user) { create(:user, :team_leader) }

      it "redirects to the root path and displays a not authorized message" do
        get conversion_voluntary_new_path
        expect(response).not_to render_template(:new)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end

      it "does not show the new project button" do
        get projects_path
        expect(response.body).not_to include(I18n.t("project.new.title"))
      end
    end
  end
end
