require "rails_helper"

RSpec.describe AssignmentsController, type: :request do
  let(:user) { create(:user, :team_leader) }

  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  shared_examples_for "an action which redirects unauthorized users" do
    let(:user) { create(:user) }

    it "redirects to the home page with a permissions error message" do
      perform_request
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash.alert).to eq I18n.t("unauthorised_action.message")
    end
  end

  describe "#assign_team_leader" do
    it_behaves_like "an action which redirects unauthorized users"

    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_assign_team_lead_path(project_id)
      response
    end

    it "returns a successful response" do
      expect(perform_request).to have_http_status :success
    end
  end

  describe "#update_team_leader" do
    context "when the project is a conversion project" do
      let(:project) { create(:conversion_project, team_leader: nil) }
      let(:project_id) { project.id }
      let(:team_leader) { create(:user, :team_leader) }

      subject(:perform_request) do
        post project_assign_team_lead_path(project_id), params: {conversion_project: {team_leader_id: team_leader.id}}
        response
      end

      it_behaves_like "an action which redirects unauthorized users"

      it "assigns the project team lead and redirects with a message" do
        expect(perform_request).to redirect_to(project_internal_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("project.assign.team_leader.success"))

        expect(project.reload.team_leader).to eq team_leader
      end
    end

    context "when the project is a transfer project" do
      let(:project) { create(:transfer_project, team_leader: nil) }
      let(:project_id) { project.id }
      let(:team_leader) { create(:user, :team_leader) }

      subject(:perform_request) do
        post project_assign_team_lead_path(project_id), params: {transfer_project: {team_leader_id: team_leader.id}}
        response
      end

      it_behaves_like "an action which redirects unauthorized users"

      it "assigns the project team lead and redirects with a message" do
        expect(perform_request).to redirect_to(project_internal_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("project.assign.team_leader.success"))

        expect(project.reload.team_leader).to eq team_leader
      end
    end
  end

  describe "#assign_regional_delivery_officer" do
    it_behaves_like "an action which redirects unauthorized users"

    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_assign_regional_delivery_officer_path(project_id)
      response
    end

    it "returns a successful response" do
      expect(perform_request).to have_http_status :success
    end
  end

  describe "#update_regional_delivery_officer" do
    context "when the project is a conversion project" do
      let(:project) { create(:conversion_project, regional_delivery_officer: nil) }
      let(:project_id) { project.id }
      let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

      subject(:perform_request) do
        post project_assign_regional_delivery_officer_path(project_id), params: {conversion_project: {regional_delivery_officer_id: regional_delivery_officer.id}}
        response
      end

      it_behaves_like "an action which redirects unauthorized users"

      it "assigns the project regional delivery officer and redirects with a message" do
        expect(perform_request).to redirect_to(project_internal_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("project.assign.regional_delivery_officer.success"))

        expect(project.reload.regional_delivery_officer).to eq regional_delivery_officer
      end
    end

    context "when the project is a transfer project" do
      let(:project) { create(:transfer_project, regional_delivery_officer: nil) }
      let(:project_id) { project.id }
      let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

      subject(:perform_request) do
        post project_assign_regional_delivery_officer_path(project_id), params: {transfer_project: {regional_delivery_officer_id: regional_delivery_officer.id}}
        response
      end

      it_behaves_like "an action which redirects unauthorized users"

      it "assigns the project regional delivery officer and redirects with a message" do
        expect(perform_request).to redirect_to(project_internal_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("project.assign.regional_delivery_officer.success"))

        expect(project.reload.regional_delivery_officer).to eq regional_delivery_officer
      end
    end
  end
end
