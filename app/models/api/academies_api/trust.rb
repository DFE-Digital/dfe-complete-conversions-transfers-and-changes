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
      ukprn: "giasData.ukprn",
      group_identifier: "giasData.groupId",
      original_name: "giasData.groupName",
      companies_house_number: "giasData.companiesHouseNumber",
      address_street: "giasData.groupContactAddress.street",
      address_locality: "giasData.groupContactAddress.locality",
      address_additional: "giasData.groupContactAddress.additionalLine",
      address_town: "giasData.groupContactAddress.town",
      address_county: "giasData.groupContactAddress.country",
      address_postcode: "giasData.groupContactAddress.postcode"
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
