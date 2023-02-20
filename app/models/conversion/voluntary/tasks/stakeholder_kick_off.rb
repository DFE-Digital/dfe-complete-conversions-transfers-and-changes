class Conversion::Voluntary::Tasks::StakeholderKickOff < TaskList::Task
  attribute :introductory_emails
  attribute :local_authority_proforma
  attribute :setup_meeting
  attribute :meeting
  attribute :confirmed_conversion_date
  attribute :check_provisional_conversion_date
  attribute "confirmed_conversion_date(3i)"
  attribute "confirmed_conversion_date(2i)"
  attribute "confirmed_conversion_date(1i)"

  validate :conversion_date_format

  def completed?
    attributes.except("confirmed_conversion_date(3i)", "confirmed_conversion_date(2i)", "confirmed_conversion_date(1i)").values.all?(&:present?)
  end

  private def conversion_date_format
    return if month.blank? && year.blank?

    format_error = I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.errors.format")

    errors.add(:confirmed_conversion_date, format_error) if month.blank? && year.present?
    errors.add(:confirmed_conversion_date, format_error) if month.present? && year.blank?
    errors.add(:confirmed_conversion_date, format_error) unless (1..12).cover?(month.to_i)
    errors.add(:confirmed_conversion_date, format_error) unless (2000..2500).cover?(year.to_i)
  end

  private def month
    attributes["confirmed_conversion_date(2i)"]
  end

  private def year
    attributes["confirmed_conversion_date(1i)"]
  end
end
