require "rails_helper"

RSpec.describe AssignedToMailer do
  describe "#assigned_notification" do
    let(:caseworker) { create(:user, :caseworker) }
    let(:project) { create(:conversion_project) }
    let(:template_id) { "ec6823ec-0aae-439b-b2f9-c626809b7c61" }
    let(:expected_personalisation) { {first_name: caseworker.first_name, project_url: project_url(project.id)} }

    subject(:send_mail) { described_class.assigned_notification(caseworker, project).deliver_now }

    before { mock_successful_api_responses(urn: any_args, ukprn: 10061021) }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: caseworker.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
