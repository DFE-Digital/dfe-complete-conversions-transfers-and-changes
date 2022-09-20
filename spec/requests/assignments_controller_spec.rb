require "rails_helper"

RSpec.describe AssignmentsController, type: :request do
  let(:user) { create(:user) }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    allow_any_instance_of(AssignmentsController).to receive(:user_id).and_return(user.id)
  end

  describe "#assign_team_leader" do
    let(:project) { create(:project) }
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
    let(:project) { create(:project, team_leader: nil) }
    let(:project_id) { project.id }
    let(:team_leader) { create(:user, :team_leader) }

    subject(:perform_request) do
      post project_assign_team_lead_path(project_id), params: {project: {team_leader_id: team_leader.id}}
      response
    end

    it "assigns the project team lead and redirefcts with a message" do
      expect(perform_request).to redirect_to(project_information_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.team_leader.success"))

      expect(project.reload.team_leader).to eq team_leader
    end
  end

  describe "#assign_regional_delivery_officer" do
    let(:project) { create(:project) }
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
    let(:project) { create(:project, regional_delivery_officer: nil) }
    let(:project_id) { project.id }
    let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

    subject(:perform_request) do
      post project_assign_regional_delivery_officer_path(project_id), params: {project: {regional_delivery_officer_id: regional_delivery_officer.id}}
      response
    end

    it "assigns the project regional delivery officer and redirefcts with a message" do
      expect(perform_request).to redirect_to(project_information_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.regional_delivery_officer.success"))

      expect(project.reload.regional_delivery_officer).to eq regional_delivery_officer
    end
  end

  describe "#assign_caseworker" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_assign_caseworker_path(project_id)
      response
    end

    it "returns a successful response" do
      expect(perform_request).to have_http_status :success
    end
  end

  describe "#update_caseworker" do
    let(:project) { create(:project, caseworker: nil) }
    let(:project_id) { project.id }
    let(:caseworker) { create(:user, :caseworker) }

    around do |spec|
      freeze_time
      spec.run
    end

    subject(:perform_request) do
      post project_assign_caseworker_path(project_id), params: {project: {caseworker_id: caseworker.id}}
      response
    end

    context "when the project has been assigned a caseworker previously" do
      let(:caseworker_assigned_at) { DateTime.yesterday.at_midday }
      let(:existing_caseworker) { create(:user, :caseworker, email: "#{SecureRandom.uuid}@education.gov.uk") }

      before { project.update(caseworker: existing_caseworker, caseworker_assigned_at: caseworker_assigned_at) }

      it "does not update the caseworker_assigned_at timestamp" do
        perform_request

        expect(project.reload.caseworker).to eq caseworker
        expect(project.reload.caseworker_assigned_at).to eq caseworker_assigned_at
      end
    end

    it "assigns the project caseworker and redirefcts with a message" do
      expect(perform_request).to redirect_to(project_information_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.caseworker.success"))

      expect(project.reload.caseworker).to eq caseworker
      expect(project.reload.caseworker_assigned_at).to eq DateTime.now
    end
  end
end
