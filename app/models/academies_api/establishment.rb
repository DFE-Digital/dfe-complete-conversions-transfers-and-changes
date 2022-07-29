class AcademiesApi::Establishment < AcademiesApi::BaseApiModel
  attr_accessor :local_authority, :name, :type

  def self.attribute_map
    {
      local_authority: "localAuthorityName",
      name: "establishmentName",
      type: "establishmentType.name"
    }
  end
end
