require "rails_helper"

RSpec.describe Conversion::Voluntary::CreateProjectForm, type: :model do
  let(:form_factory) { "create_voluntary_project_form" }
  let(:workflow_path) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:details_class) { "Conversion::Voluntary::Details" }

  it_behaves_like "a conversion project FormObject"

  context "when the project is successfully created" do
    let(:establishment) { build(:academies_api_establishment) }
    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)

      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end

    it "sends a notification to team leaders" do
      team_leader = create(:user, :team_leader)
      another_team_leader = create(:user, :team_leader)

      project = build(:create_voluntary_project_form).save

      expect(ActionMailer::MailDeliveryJob)
        .to(have_been_enqueued.on_queue("default")
        .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, project]))
      expect(ActionMailer::MailDeliveryJob)
        .to(have_been_enqueued.on_queue("default")
        .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [another_team_leader, project]))
    end
  end
end
