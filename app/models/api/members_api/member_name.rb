class Api::MembersApi::MemberName < Api::BaseApiModel
  attr_accessor(
    :id,
    :name_list_as,
    :name_display_as,
    :name_full_title,
    :name_address_as
  )

  def self.attribute_map
    {
      id: "id",
      name_list_as: "nameListAs",
      name_display_as: "nameDisplayAs",
      name_full_title: "nameFullTitle",
      name_address_as: "nameAddressAs"
    }
  end
end
