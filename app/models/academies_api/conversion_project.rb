class AcademiesApi::ConversionProject < AcademiesApi::BaseApiModel
  attr_accessor :name_of_trust
  attr_writer :proposed_opening_date

  def proposed_opening_date
    Date.parse(@proposed_opening_date)
  end

  def self.attribute_map
    {
      name_of_trust: "nameOfTrust",
      proposed_opening_date: "proposedAcademyOpeningDate"
    }
  end
end
