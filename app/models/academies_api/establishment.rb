class AcademiesApi::Establishment < AcademiesApi::BaseApiModel
  attr_accessor(
    :urn,
    :name,
    :local_authority,
    :type,
    :age_range_lower,
    :age_range_upper,
    :phase,
    :diocese_name,
    :region_name
  )

  def self.attribute_map
    {
      urn: "urn",
      name: "establishmentName",
      local_authority: "localAuthorityName",
      type: "establishmentType.name",
      age_range_lower: "statutoryLowAge",
      age_range_upper: "statutoryHighAge",
      phase: "phaseOfEducation.name",
      diocese_name: "diocese.name",
      region_name: "gor.name"
    }
  end
end
