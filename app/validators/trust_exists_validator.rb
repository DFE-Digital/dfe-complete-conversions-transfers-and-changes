class TrustExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    result = Api::AcademiesApi::Client.new.get_trust(value.to_i)
    raise result.error if result.error.present?
  rescue Api::AcademiesApi::Client::NotFoundError
    record.errors.add(attribute, :no_trust_found)
  end
end
