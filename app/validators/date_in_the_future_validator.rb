class DateInTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    unless value.future?
      record.errors.add(attribute, :must_be_in_the_future)
    end
  end
end
