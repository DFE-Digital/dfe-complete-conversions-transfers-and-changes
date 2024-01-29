class ExistingAcademyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value

    establishment = Gias::Establishment.find_by(urn: value)
    return unless establishment

    if establishment.is_academy?
      record.errors.add(attribute, :is_an_academy)
    end
  end
end
