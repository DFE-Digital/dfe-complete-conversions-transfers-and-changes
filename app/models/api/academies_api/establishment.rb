class Api::AcademiesApi::Establishment < Api::BaseApiModel
  DIOCESE_NOT_APPLICABLE_CODE = "0000"

  attr_accessor(
    :urn,
    :name,
    :establishment_number,
    :local_authority_name,
    :local_authority_code,
    :type,
    :type_code,
    :age_range_lower,
    :age_range_upper,
    :phase,
    :diocese_name,
    :diocese_code,
    :region_name,
    :region_code,
    :parliamentary_constituency,
    :address_street,
    :address_locality,
    :address_additional,
    :address_town,
    :address_county,
    :address_postcode
  )

  def self.attribute_map
    {
      urn: "urn",
      name: "establishmentName",
      establishment_number: "establishmentNumber",
      local_authority_name: "localAuthorityName",
      local_authority_code: "localAuthorityCode",
      type: "establishmentType.name",
      type_code: "establishmentType.code",
      age_range_lower: "statutoryLowAge",
      age_range_upper: "statutoryHighAge",
      phase: "phaseOfEducation.name",
      diocese_name: "diocese.name",
      diocese_code: "diocese.code",
      region_name: "gor.name",
      region_code: "gor.code",
      parliamentary_constituency: "parliamentaryConstituency.name",
      address_street: "address.street",
      address_locality: "address.locality",
      address_additional: "address.additionalLine",
      address_town: "address.town",
      address_county: "address.country",
      address_postcode: "address.postcode"
    }
  end

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
