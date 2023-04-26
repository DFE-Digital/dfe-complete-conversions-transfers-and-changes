class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    ukpc = UKPostcode.parse(value)
    unless ukpc.full_valid?
      record.errors.add(attribute, "not recognised as a UK postcode")
    end
  end
end
