require "rails_helper"

RSpec.describe "Project management" do
  before do
    sign_in_with(user)
  end

  describe "creating a new project" do
    context "when the user is a regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }
      it "allows the action and renders the new template" do
        get new_conversions_voluntary_project_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end

      it "shows the new project button" do
        get projects_path
        expect(response.body).to include(I18n.t("conversion_project.voluntary.new.title"))
      end
    end

    context "when a user is a caseworker" do
      let(:user) { create(:user, :caseworker) }

      it "redirects to the root path and displays a not authorized message" do
        get new_conversions_voluntary_project_path
        expect(response).not_to render_template(:new)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end

      it "does not show the new project button" do
        get projects_path
        expect(response.body).not_to include(I18n.t("conversion_project.voluntary.new.title"))
      end
    end

    context "when the user is a team lead" do
      let(:user) { create(:user, :team_leader) }

      it "redirects to the root path and displays a not authorized message" do
        get new_conversions_voluntary_project_path
        expect(response).not_to render_template(:new)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end

      it "does not show the new project button" do
        get projects_path
        expect(response.body).not_to include(I18n.t("conversion_project.voluntary.new.title"))
      end
    end
  end
end
