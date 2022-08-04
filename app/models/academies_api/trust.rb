class AcademiesApi::Trust < AcademiesApi::BaseApiModel
  attr_accessor(
    :name,
    :companies_house_number
  )

  def self.attribute_map
    {
      name: "data.giasData.groupName",
      companies_house_number: "data.giasData.companiesHouseNumber"
    }
  end
end
