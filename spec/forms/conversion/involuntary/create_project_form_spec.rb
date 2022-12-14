require "rails_helper"

RSpec.describe Conversion::Involuntary::CreateProjectForm, type: :model do
  let(:form_factory) { "create_involuntary_project_form" }
  let(:workflow_path) { Conversion::Involuntary::Details::WORKFLOW_PATH }
  let(:details_class) { "Conversion::Involuntary::Details" }
  let(:task_list_class) { Conversion::Involuntary::TaskList }

  it_behaves_like "a conversion project FormObject"

  context "when the project is successfully created" do
    let(:establishment) { build(:academies_api_establishment) }
    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)

      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end

    it "does not send a notification to team leaders" do
      _team_leader = create(:user, :team_leader)
      _another_team_leader = create(:user, :team_leader)

      _project = build(:create_involuntary_project_form).save

      expect(ActionMailer::MailDeliveryJob).to_not(have_been_enqueued)
    end
  end
end
