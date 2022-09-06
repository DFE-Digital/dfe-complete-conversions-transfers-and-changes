class AcademiesApi::Establishment < AcademiesApi::BaseApiModel
  attr_accessor(
    :name,
    :local_authority,
    :type,
    :age_range_lower,
    :age_range_upper,
    :phase,
    :diocese_name
  )

  def self.attribute_map
    {
      name: "establishmentName",
      local_authority: "localAuthorityName",
      type: "establishmentType.name",
      age_range_lower: "statutoryLowAge",
      age_range_upper: "statutoryHighAge",
      phase: "phaseOfEducation.name",
      diocese_name: "diocese.name"
    }
  end
end
