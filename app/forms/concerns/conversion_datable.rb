module ConversionDatable
  extend ActiveSupport::Concern

  included do
    attribute :confirmed_conversion_date, :date
    attribute "confirmed_conversion_date(1i)"
    attribute "confirmed_conversion_date(2i)"
    attribute "confirmed_conversion_date(3i)"

    validate :conversion_date_format
    validate :conversion_date_in_the_future, if: -> { valid_month? && valid_year? }
  end

  private def conversion_date_format
    return if month.blank? && year.blank?

    format_error = I18n.t("conversion.task.stakeholder_kick_off.confirmed_conversion_date.errors.format")

    errors.add(:confirmed_conversion_date, format_error) if month.blank? || year.blank?
    errors.add(:confirmed_conversion_date, format_error) unless valid_month?
    errors.add(:confirmed_conversion_date, format_error) unless valid_year?
  end

  private def conversion_date_in_the_future
    in_the_future_error = I18n.t("conversion.task.stakeholder_kick_off.confirmed_conversion_date.errors.in_the_future")
    errors.add(:confirmed_conversion_date, in_the_future_error) unless Date.new(year, month, 1).future?
  end

  private def month
    attributes["confirmed_conversion_date(2i)"].to_i
  end

  private def year
    attributes["confirmed_conversion_date(1i)"].to_i
  end

  private def valid_month?
    (1..12).cover?(month)
  end

  private def valid_year?
    (2000..2500).cover?(year)
  end
end
