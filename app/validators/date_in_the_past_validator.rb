class DateInThePastValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    unless value.past?
      record.errors.add(attribute, :must_be_in_the_past)
    end
  end
end
