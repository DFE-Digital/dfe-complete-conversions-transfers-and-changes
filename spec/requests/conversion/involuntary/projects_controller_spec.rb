require "rails_helper"

RSpec.describe Conversion::Involuntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_involuntary_new_path }
  let(:workflow_root) { Conversion::Involuntary::Details::WORKFLOW_PATH }
  let(:this_controller) { Conversion::Involuntary::ProjectsController }

  before do
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"

  describe "notifications" do
    context "when a new involuntary conversion project is created" do
      it "does not send a notification to team leaders" do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)
        project_params = attributes_for(:conversion_project)
        _team_leader = create(:user, :team_leader)
        _another_team_leader = create(:user, :team_leader)

        post create_path, params: {conversion_project: {**project_params, note: {body: ""}}}

        expect(ActionMailer::MailDeliveryJob).not_to(have_been_enqueued.on_queue("default"))
      end
    end
  end
end
