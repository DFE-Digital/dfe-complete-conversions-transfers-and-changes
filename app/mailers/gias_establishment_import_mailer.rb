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
      Total CSV rows: #{result[:result][:total_csv_rows]}
      New records: #{result[:result][:new_records]}
      Changed records: #{result[:result][:changed_records]}
      Time: #{result[:result][:time].strftime("%Y-%m-%d %H:%M")}
      Errors: #{result[:result][:errors].count}
    TEXT
  end
end
