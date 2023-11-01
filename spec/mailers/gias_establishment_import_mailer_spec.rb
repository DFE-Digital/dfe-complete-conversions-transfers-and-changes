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
    let(:expected_personalisation) do
      {result:
       <<~TEXT
         File: #{result[:file]}
         Time taken: #{result[:time_taken]}
         CSV rows: #{result[:total_csv_rows]}
         CSV rows skipped: #{result[:skipped_csv_rows]}
         New records: #{result[:new]}
         Changed records: #{result[:changed]}
         Unchanged records: #{result[:no_changes]}
       TEXT
      }
    end

    subject(:send_mail) { described_class.import_notification(user, result).deliver_now }

    it "sends an email with the correct personalisation" do
      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with(template_id, {to: user.email, personalisation: expected_personalisation})

      send_mail
    end
  end
end
