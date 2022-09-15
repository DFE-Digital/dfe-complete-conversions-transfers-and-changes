class UkprnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.to_s.match?("^1[0-9]{7}$")
      record.errors.add(attribute, :must_be_correct_format)
    end
  end
end
