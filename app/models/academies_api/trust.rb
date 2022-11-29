class AcademiesApi::Trust < AcademiesApi::BaseApiModel
  attr_accessor(
    :original_name,
    :companies_house_number
  )

  def name
    original_name.titleize
  end

  def self.attribute_map
    {
      original_name: "giasData.groupName",
      companies_house_number: "giasData.companiesHouseNumber"
    }
  end
end
