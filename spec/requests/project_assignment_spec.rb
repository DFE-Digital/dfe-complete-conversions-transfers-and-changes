require "rails_helper"

RSpec.describe "Project assignment" do
  describe "assigning a project" do
    let(:project) { create_unassigned_project }

    before do
      mock_successful_authentication(user.email)
      mock_successful_api_responses(urn: project.urn, ukprn: project.incoming_trust_ukprn)
      allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(user.id)
    end

    context "when the user is a team lead" do
      let(:user) { create(:user, :team_leader) }
      let(:caseworker) { create(:user, email: "case.worker@education.gov.uk") }

      before { freeze_time }

      it "shows the edit project button" do
        get project_path(project)
        expect(response.body).to include("Edit")
      end

      it "allows the action and renders the edit template" do
        get edit_project_path(project)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end

      it "assigns the current user as the team lead" do
        patch project_path(project, params: {project: {caseworker_id: caseworker.id}})

        expect(project.reload.team_leader).to eq user
      end

      it "assigns the caseworker and caseworker_assigned_at timestamp" do
        patch project_path(project, params: {project: {caseworker_id: caseworker.id}})

        expect(project.reload.caseworker).to eq caseworker
        expect(project.reload.caseworker_assigned_at).to eq DateTime.now
      end

      context "when a caseworker has been assigned previously" do
        let(:caseworker_assigned_at) { DateTime.yesterday.at_midday }
        let(:new_caseworker) { create(:user, :caseworker) }

        before { project.update(caseworker: caseworker, caseworker_assigned_at: caseworker_assigned_at) }

        it "does not update the caseworker_assigned_at timestamp" do
          patch project_path(project, params: {project: {caseworker_id: new_caseworker.id}})

          expect(project.reload.caseworker).to eq new_caseworker
          expect(project.reload.caseworker_assigned_at).to eq caseworker_assigned_at
        end
      end
    end

    context "when a user is a caseworker" do
      let(:user) { create(:user, :caseworker) }

      it "does not show the new project button" do
        get project_path(project)
        expect(response.body).not_to include("Edit")
      end

      it "redirects to the root path and displays a not authorized message" do
        get edit_project_path(project)
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "when the user is a regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      it "does not show the new project button" do
        get project_path(project)
        expect(response.body).not_to include("Edit")
      end

      it "redirects to the root path and displays a not authorized message" do
        get edit_project_path(project)
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end
  end
end
