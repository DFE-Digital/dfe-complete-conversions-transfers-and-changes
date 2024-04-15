class FormAMultiAcademyTrustNameValidator < ActiveModel::Validator
  def validate(record)
    return if record.new_trust_reference_number.blank? || record.new_trust_name.blank?

    other_project = Project.find_by_new_trust_reference_number(record.new_trust_reference_number)
    trust_name = other_project&.new_trust_name

    unless trust_name.blank? || record.new_trust_name.upcase.eql?(trust_name.upcase)
      record.errors.add(
        :new_trust_name,
        :not_matching,
        message: I18n.t("errors.attributes.new_trust_name.not_matching", trust_name: trust_name)
      )
    end
  end
end
