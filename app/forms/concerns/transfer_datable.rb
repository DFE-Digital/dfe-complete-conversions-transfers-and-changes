module TransferDatable
  extend ActiveSupport::Concern

  included do
    attribute "confirmed_transfer_date(1i)"
    attribute "confirmed_transfer_date(2i)"
    attribute "confirmed_transfer_date(3i)"

    validate :transfer_date_format
  end

  def confirmed_transfer_date
    Date.new(year, month, 1) if valid_year? && valid_month?
  end

  private def transfer_date_format
    return if month.nil? && year.nil?

    format_error = I18n.t("transfer.task.stakeholder_kick_off.confirmed_transfer_date.errors.format")

    errors.add(:confirmed_transfer_date, format_error) if month.blank? || year.blank?
    errors.add(:confirmed_transfer_date, format_error) unless valid_month?
    errors.add(:confirmed_transfer_date, format_error) unless valid_year?
  end

  private def month
    month = attributes["confirmed_transfer_date(2i)"]
    return if month.blank?

    month.to_i
  end

  private def year
    year = attributes["confirmed_transfer_date(1i)"]
    return if year.blank?

    year.to_i
  end

  private def valid_month?
    (1..12).cover?(month)
  end

  private def valid_year?
    (2000..2500).cover?(year)
  end
end
