require "rails_helper"

RSpec.describe Conversion::Voluntary::CreateProjectForm, type: :model do
  let(:form_factory) { "create_voluntary_project_form" }
  let(:task_list_class) { Conversion::Voluntary::TaskList }

  it_behaves_like "a conversion project FormObject"

  context "when the project is successfully created" do
    let(:establishment) { build(:academies_api_establishment) }
    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)

      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end

    context "when the project is being assigned to the Regional Caseworker Team" do
      it "sends a notification to team leaders" do
        team_leader = create(:user, :team_leader)
        another_team_leader = create(:user, :team_leader)

        project = build(:create_voluntary_project_form, assigned_to_regional_caseworker_team: true).save

        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, project]))
        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [another_team_leader, project]))
      end

      it "does not set Project.assigned_to" do
        project = build(:create_voluntary_project_form, assigned_to_regional_caseworker_team: true).save

        expect(project.assigned_to).to be_nil
      end
    end

    context "when the project is NOT being assigned to the Regional Caseworker Team" do
      it "does not send a notification to team leaders" do
        _team_leader = create(:user, :team_leader)
        _another_team_leader = create(:user, :team_leader)

        _project = build(:create_voluntary_project_form, assigned_to_regional_caseworker_team: false).save

        expect(ActionMailer::MailDeliveryJob).to_not(have_been_enqueued)
      end

      it "sets Project.assigned_to the current user" do
        project = build(:create_voluntary_project_form, assigned_to_regional_caseworker_team: false).save

        expect(project.assigned_to).to_not be_nil
      end
    end
  end
end
