class GiasHeadteacherImportMailer < ApplicationMailer
  def import_notification(user, result)
    template_mail(
      "6d4ea487-3d6f-4043-b7dc-2388ed373fbc",
      to: user.email,
      personalisation: {
        result: format_result(result)
      }
    )
  end

  private def format_result(result)
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
  end
end
