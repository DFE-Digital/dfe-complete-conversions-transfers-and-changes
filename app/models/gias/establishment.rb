class Gias::Establishment < ApplicationRecord
  self.table_name = :gias_establishments

  validates :urn, presence: true

  alias_attribute :phase, :phase_name
  alias_attribute :type, :type_name
  alias_attribute :status, :status_name

  DIOCESE_NOT_APPLICABLE_CODE = "0000"
  ACADEMY_CODES = %w[46 45 42 43 34 44 33 28 57]

  def address
    [
      address_street,
      address_locality,
      address_additional,
      address_town,
      address_county,
      address_postcode
    ]
  end

  def local_authority
    LocalAuthority.find_by(code: local_authority_code)
  end

  def dfe_number
    return unless local_authority_code.present? && establishment_number.present?

    "#{local_authority_code}/#{establishment_number}"
  end
  alias_method :laestab, :dfe_number

  def has_diocese?
    diocese_code != DIOCESE_NOT_APPLICABLE_CODE
  end

  def is_academy?
    ACADEMY_CODES.include?(type_code)
  end
end
