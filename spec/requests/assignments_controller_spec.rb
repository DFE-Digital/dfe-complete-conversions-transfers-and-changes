require "rails_helper"

RSpec.describe AssignmentsController, type: :request do
  let(:user) { create(:user, :team_leader) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
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

    let(:project) { create(:voluntary_conversion_project) }
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
    it_behaves_like "an action which redirects unauthorized users"

    let(:project) { create(:conversion_project, team_leader: nil) }
    let(:project_id) { project.id }
    let(:team_leader) { create(:user, :team_leader) }

    subject(:perform_request) do
      post project_assign_team_lead_path(project_id), params: {conversion_project: {team_leader_id: team_leader.id}}
      response
    end

    it "assigns the project team lead and redirects with a message" do
      expect(perform_request).to redirect_to(project_internal_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.team_leader.success"))

      expect(project.reload.team_leader).to eq team_leader
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
    it_behaves_like "an action which redirects unauthorized users"

    let(:project) { create(:conversion_project, regional_delivery_officer: nil) }
    let(:project_id) { project.id }
    let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

    subject(:perform_request) do
      post project_assign_regional_delivery_officer_path(project_id), params: {conversion_project: {regional_delivery_officer_id: regional_delivery_officer.id}}
      response
    end

    it "assigns the project regional delivery officer and redirefcts with a message" do
      expect(perform_request).to redirect_to(project_internal_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.regional_delivery_officer.success"))

      expect(project.reload.regional_delivery_officer).to eq regional_delivery_officer
    end
  end

  describe "#assign_assigned_to" do
    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_assign_assigned_to_path(project_id)
      response
    end

    it "returns a successful response" do
      expect(perform_request).to have_http_status :success
    end

    context "when the user is a not a team leader" do
      let(:user) { create(:user, :caseworker) }

      it "returns a successful response" do
        expect(perform_request).to have_http_status :success
      end
    end
  end

  describe "#update_assigned_to" do
    let(:project) { create(:conversion_project, assigned_to: nil) }
    let(:project_id) { project.id }
    let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

    subject(:perform_request) do
      post project_assign_assigned_to_path(project_id), params: {conversion_project: {assigned_to_id: regional_delivery_officer.id}}
      response
    end

    around do |spec|
      freeze_time
      spec.run
    end

    it "assigns the project assignee and redirects with a message" do
      expect(perform_request).to redirect_to(project_internal_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("project.assign.assigned_to.success"))

      expect(project.reload.assigned_to).to eq regional_delivery_officer
    end

    it "sends a notification to the assigned_to person" do
      perform_request

      expect(ActionMailer::MailDeliveryJob)
        .to(have_been_enqueued.on_queue("default")
        .with("AssignedToMailer", "assigned_notification", "deliver_now", args: [regional_delivery_officer, Project.last]))
    end

    context "the assigned_to person is deactivated" do
      it "does not send a notification to the assigned_to person" do
        regional_delivery_officer.update!(deactivated_at: Date.yesterday)

        perform_request

        expect(ActionMailer::MailDeliveryJob)
          .to_not(have_been_enqueued.on_queue("default")
                                .with("AssignedToMailer", "assigned_notification", "deliver_now", args: [regional_delivery_officer, Project.last]))
      end
    end

    it "sets the `assigned_at` date value" do
      perform_request

      expect(project.reload.assigned_at).to eq DateTime.now
    end

    context "when the project has been assigned previously" do
      let(:previously_assigned_at) { DateTime.yesterday.at_midday }
      let(:previous_user) { create(:user, :caseworker, email: "#{SecureRandom.uuid}@education.gov.uk") }

      before { project.update(assigned_to: previous_user, assigned_at: previously_assigned_at) }

      it "does not update the assigned_at timestamp" do
        perform_request

        expect(project.reload.assigned_to).to eq regional_delivery_officer
        expect(project.reload.assigned_at).to eq previously_assigned_at
      end
    end

    context "when the user is a not a team leader" do
      let(:user) { create(:user, :caseworker) }

      it "assigns the project assignee and redirects with a message" do
        expect(perform_request).to redirect_to(project_internal_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("project.assign.assigned_to.success"))

        expect(project.reload.assigned_to).to eq regional_delivery_officer
      end
    end
  end
end
