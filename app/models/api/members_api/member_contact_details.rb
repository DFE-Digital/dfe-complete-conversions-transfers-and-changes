class Api::MembersApi::MemberContactDetails < Api::BaseApiModel
  attr_accessor(
    :type,
    :type_description,
    :type_id,
    :is_preferred,
    :is_web_address,
    :notes,
    :line1,
    :line2,
    :postcode,
    :phone,
    :email
  )

  def self.attribute_map
    {
      type: "type",
      type_description: "typeDescription",
      type_id: "typeId",
      is_preferred: "isPreferred",
      is_web_address: "isWebAddress",
      notes: "notes",
      line1: "line1",
      line2: "line2",
      postcode: "postcode",
      phone: "phone",
      email: "email"
    }
  end

  def address
    [
      line1,
      line2,
      postcode
    ]
  end
end
