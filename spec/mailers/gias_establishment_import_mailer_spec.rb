require "rails_helper"

RSpec.describe GiasEstablishmentImportMailer do
  describe "#import_notification" do
    let(:user) { create(:user, :service_support) }
    let(:template_id) { "316ef413-5e53-48e4-8a78-2aeaa9b98114" }
    let(:result) do
      {total_csv_rows: 10,
       new_establishment_records: 1,
       changed_establishment_records: 2,
       new_contact_records: 1,
       changed_contact_records: 2,
       changes: 0,
       time: DateTime.now,
       errors: {establishment: [], contact: []}}
    end
    let(:expected_personalisation) { {result: "Total CSV rows: 10\nNew establishment records: 1\nChanged establishment records: 2\nNew contact records: 1\nChanged contact records: 2\nTime: #{DateTime.now.strftime("%Y-%m-%d %H:%M")}\nEstablishment errors: 0\nContact errors: 0\n"} }

    subject(:send_mail) { described_class.import_notification(user, result).deliver_now }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: user.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
