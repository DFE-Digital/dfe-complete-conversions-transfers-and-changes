class Api::AcademiesApi::Trust < Api::BaseApiModel
  attr_accessor(
    :ukprn,
    :group_identifier,
    :original_name,
    :companies_house_number,
    :address_street,
    :address_locality,
    :address_additional,
    :address_town,
    :address_county,
    :address_postcode
  )

  def name
    original_name.titleize
  end

  def self.attribute_map
    {
      ukprn: "ukprn",
      group_identifier: "referenceNumber",
      original_name: "name",
      companies_house_number: "companiesHouseNumber",
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
