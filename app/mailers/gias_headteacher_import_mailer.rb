class GiasHeadteacherImportMailer < ApplicationMailer
  def import_notification(user, result)
    template_mail(
      "316ef413-5e53-48e4-8a78-2aeaa9b98114",
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
