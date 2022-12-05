class AcademiesApi::Trust < AcademiesApi::BaseApiModel
  attr_accessor(
    :ukprn,
    :original_name,
    :companies_house_number
  )

  def name
    original_name.titleize
  end

  def self.attribute_map
    {
      ukprn: "giasData.ukprn",
      original_name: "giasData.groupName",
      companies_house_number: "giasData.companiesHouseNumber"
    }
  end
end
