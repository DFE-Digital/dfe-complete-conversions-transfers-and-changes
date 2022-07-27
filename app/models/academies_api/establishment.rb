class AcademiesApi::Establishment < AcademiesApi::BaseApiModel
  attr_accessor :local_authority, :name

  def self.attribute_map
    {
      local_authority: "localAuthorityName",
      name: "establishmentName"
    }
  end
end
