require "rails_helper"

RSpec.describe Conversion::Voluntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_voluntary_new_path }
  let(:workflow_root) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:form_class) { Conversion::Voluntary::CreateProjectForm }
  let(:project_form) { build(:create_voluntary_project_form) }
  let(:project_form_params) {
    attributes_for(:create_voluntary_project_form,
      "provisional_conversion_date(3i)": "1",
      "provisional_conversion_date(2i)": "1",
      "provisional_conversion_date(1i)": "2030",
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil)
  }

  before do
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"

  describe "notifications" do
    context "when a new voluntary conversion project is created" do
      before do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)
        project = create(:voluntary_conversion_project)
        create_project_form = build(:create_voluntary_project_form)
        allow(Conversion::Voluntary::CreateProjectForm).to receive(:new).and_return(create_project_form)
        allow(create_project_form).to receive(:save).and_return(project)
      end

      it "sends a notification to team leaders" do
        team_leader = create(:user, :team_leader)
        another_team_leader = create(:user, :team_leader)
        project_form_params = attributes_for(:create_voluntary_project_form, user: regional_delivery_officer)

        post create_path, params: {conversion_project: {**project_form_params, note: {body: ""}}}

        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
          .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, Project.last]))
        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
          .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [another_team_leader, Project.last]))
      end
    end
  end
end
