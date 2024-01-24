class DateInThePastValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    if value.year < 2010
      record.errors.add(attribute, :must_be_within_parameters)
    end

    unless value.past? || value.today?
      record.errors.add(attribute, :must_be_in_the_past)
    end
  end
end
