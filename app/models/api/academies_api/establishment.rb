class Api::AcademiesApi::Establishment < Api::BaseApiModel
  attr_accessor(
    :urn,
    :name,
    :local_authority_name,
    :type,
    :age_range_lower,
    :age_range_upper,
    :phase,
    :diocese_name,
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
      local_authority_name: "localAuthorityName",
      type: "establishmentType.name",
      age_range_lower: "statutoryLowAge",
      age_range_upper: "statutoryHighAge",
      phase: "phaseOfEducation.name",
      diocese_name: "diocese.name",
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
end
