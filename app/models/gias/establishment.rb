class Gias::Establishment < ApplicationRecord
  self.table_name = :gias_establishments

  validates :urn, presence: true

  alias_attribute :phase, :phase_name
  alias_attribute :type, :type_name

  DIOCESE_NOT_APPLICABLE_CODE = "0000"

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
    "#{local_authority_code}/#{establishment_number}"
  end

  def has_diocese?
    diocese_code != DIOCESE_NOT_APPLICABLE_CODE
  end
end
