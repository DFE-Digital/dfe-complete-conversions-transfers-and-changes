class AcademiesApi::ConversionProject < AcademiesApi::BaseApiModel
  attr_accessor :name_of_trust

  def self.attribute_map
    {
      name_of_trust: "nameOfTrust"
    }
  end
end
