require "rails_helper"

RSpec.describe GiasEstablishmentImportMailer do
  describe "#import_notification" do
    let(:user) { create(:user, :service_support) }
    let(:template_id) { "316ef413-5e53-48e4-8a78-2aeaa9b98114" }
    let(:result) do
      {total_csv_rows: 10,
       new_records: 1,
       changed_records: 2,
       changes: 0,
       time: 189.23232,
       errors: []}
    end
    let(:expected_personalisation) { {result: "Total CSV rows: 10\nNew records: 1\nChanged records: 2\nTime: 189.23232\nErrors: 0\n"} }

    subject(:send_mail) { described_class.import_notification(user, result).deliver_now }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: user.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
