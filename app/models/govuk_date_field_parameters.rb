class GovukDateFieldParameters
  # The years range top and tails the year input to something reasonable as
  # Ruby Dates can be negative and unreasonable values like 100 or 0.
  # do not try to use this as regular validation of the year value, use Rails
  # validators for that only override it the default range is unsuitable and you
  # want the range consistent across the application.
  YEARS_RANGE = (2000..3000)

  def initialize(attribute_name, params, **options)
    @params = params
    @attribute_name = attribute_name.to_sym
    @years_range = options[:years_range] || YEARS_RANGE
    @without_day = options[:without_day] || false
  end

  def valid?
    return true unless parameters_present?
    return true if values_empty?
    return false unless values_in_range?

    valid_date?
  end

  def invalid?
    !valid?
  end

  # If the parameters are not present we have to assume the current value of
  # the date is valid, we only deal with changes via form submission.
  #
  # When omitting the day value in a form, you will still be sent '1' as the day:
  # https://govuk-form-builder.netlify.app/form-elements/date-input/#approximate-dates-recording-the-closest-month
  private def parameters_present?
    @params.has_key?(year_key) &&
      @params.has_key?(month_key) &&
      @params.has_key?(day_key)
  end

  # nil is a valid date to store and can be set when the parameters are present and
  # empty, this allows the form to be submitted with blank values, Rails presence
  # validation can be used later if you do not want nil dates
  private def values_empty?
    if @without_day
      day_value.eql?("1") && month_value.blank? && year_value.blank?
    else
      year_value.blank? && month_value.blank? && day_value.blank?
    end
  end

  # Ruby Dates are very flexible and accept many values that would confuse users,
  # we make sure the three values fall in to reasonable ranges to exclude things
  # like negative values.
  #
  # This also catches any strings that were cast to integers as `0`.
  private def values_in_range?
    (1..31).cover?(day_value.to_i) &&
      (1..12).cover?(month_value.to_i) &&
      @years_range.cover?(year_value.to_i)
  end

  # If all other validations have succeeded, we convert the three values to a Date
  # object, this catches anything left, leap years for example or months that do
  # not have 31 days.
  private def valid_date?
    Date.new(year_value.to_i, month_value.to_i, day_value.to_i)
    true
  rescue Date::Error
    false
  end

  # Accessors for the keys and values, we keep the values as strings, casting to
  # integers only when required so we can deal with empty strings ("").
  private def year_key
    "#{@attribute_name}(1i)"
  end

  private def month_key
    "#{@attribute_name}(2i)"
  end

  private def day_key
    "#{@attribute_name}(3i)"
  end

  private def year_value
    @params.fetch(year_key)
  end

  private def month_value
    @params.fetch(month_key)
  end

  private def day_value
    @params.fetch(day_key)
  end
end
