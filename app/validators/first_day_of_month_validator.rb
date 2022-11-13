class FirstDayOfMonthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    unless value.day == 1
      record.errors.add(attribute, :must_be_first_of_the_month)
    end
  end
end
