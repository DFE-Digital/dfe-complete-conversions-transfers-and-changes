class AcademiesApi::Establishment < AcademiesApi::BaseApiModel
  attr_accessor :name

  def self.attribute_map
    {
      name: "establishmentName"
    }
  end
end
