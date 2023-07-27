module SignificantDatable
  extend ActiveSupport::Concern

  included do
    attribute "confirmed_significant_date(1i)"
    attribute "confirmed_significant_date(2i)"
    attribute "confirmed_significant_date(3i)"

    validate :significant_date_format
    validate :significant_date_in_the_future, if: -> { valid_month? && valid_year? }
  end

  def confirmed_significant_date
    return Date.new(year, month, 1) if valid_year? && valid_month?
  end

  private def significant_date_format
    return if month.nil? && year.nil?

    format_error = I18n.t("errors.attributes.confirmed_significant_date.format")

    errors.add(:confirmed_significant_date, format_error) if month.blank? || year.blank?
    errors.add(:confirmed_significant_date, format_error) unless valid_month?
    errors.add(:confirmed_significant_date, format_error) unless valid_year?
  end

  private def significant_date_in_the_future
    in_the_future_error = I18n.t("errors.attributes.confirmed_significant_date.in_the_future")
    errors.add(:confirmed_significant_date, in_the_future_error) unless Date.new(year, month, 1).future?
  end

  private def month
    month = attributes["confirmed_significant_date(2i)"]
    return if month.blank?

    month.to_i
  end

  private def year
    year = attributes["confirmed_significant_date(1i)"]
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
