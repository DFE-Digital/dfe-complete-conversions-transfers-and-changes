require "rails_helper"

RSpec.describe GiasHeadteacherImportMailer do
  describe "#import_notification" do
    let(:user) { create(:user, :service_support) }
    let(:template_id) { "316ef413-5e53-48e4-8a78-2aeaa9b98114" }
    let(:result) do
      {
        file: "/a/file.csv",
        total_csv_rows: 10,
        total_csv_rows_with_a_contact: 10,
        skipped_csv_rows: 1,
        new_contacts: 5,
        contacts_changed: 2,
        contacts_not_changed: 3,
        time_taken: 123.1234,
        changes: {}
      }
    end
    let(:expected_personalisation) do
      {result:
        <<~TEXT
          File: #{result[:file]}
          Time taken: #{result[:time_taken]}
          CSV rows: #{result[:total_csv_rows]}
          CSV rows with a contact: #{result[:total_csv_rows_with_a_contact]}
          CSV rows skipped: #{result[:skipped_csv_rows]}
          New records: #{result[:new_contacts]}
          Changed records: #{result[:contacts_changed]}
          Unchanged records: #{result[:contacts_not_changed]}
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
