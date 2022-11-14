class UrnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.to_s.match?(/^[0-9]{6}$/)
      record.errors.add(attribute, :invalid_urn)
    end
  end
end
