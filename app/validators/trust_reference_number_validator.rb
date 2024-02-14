class TrustReferenceNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.to_s.match?(/^TR\d{5}$/)
      record.errors.add(attribute, :invalid_trust_reference_number)
    end
  end
end
