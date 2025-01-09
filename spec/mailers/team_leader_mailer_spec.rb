require "rails_helper"

RSpec.describe TeamLeaderMailer do
  describe "#new_conversion_project_created" do
    let(:team_leader) { create(:user, :team_leader) }
    let(:project) { create(:conversion_project) }
    let(:template_id) { "ea4f72e4-f5bb-4b1a-b5f9-a94cc1840353" }
    let(:expected_personalisation) { {first_name: team_leader.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.new_conversion_project_created(team_leader, project).deliver_now }

    before { mock_successful_api_responses(urn: any_args, ukprn: 10061021) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: team_leader.email, personalisation: expected_personalisation})

      send_mail
    end
  end

  describe "#new_transfer_project_created" do
    let(:team_leader) { create(:user, :team_leader) }
    let(:project) { create(:transfer_project) }
    let(:template_id) { "b0df8e28-ea23-46c5-9a83-82abc6b29193" }
    let(:expected_personalisation) { {first_name: team_leader.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.new_transfer_project_created(team_leader, project).deliver_now }

    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: team_leader.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
