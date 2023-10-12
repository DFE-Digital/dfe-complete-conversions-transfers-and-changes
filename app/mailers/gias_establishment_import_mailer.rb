class GiasEstablishmentImportMailer < ApplicationMailer
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
      Total CSV rows: #{result[:total_csv_rows]}
      New establishment records: #{result[:new_establishment_records]}
      Changed establishment records: #{result[:changed_establishment_records]}
      Time: #{result[:time].strftime("%Y-%m-%d %H:%M")}
      Establishment errors: #{result[:errors][:establishment].count}
    TEXT
  end
end
