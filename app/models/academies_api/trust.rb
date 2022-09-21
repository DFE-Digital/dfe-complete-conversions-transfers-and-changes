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
      original_name: "data.giasData.groupName",
      companies_house_number: "data.giasData.companiesHouseNumber"
    }
  end
end
