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
    :line3,
    :line4,
    :line5,
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
      line3: "line3",
      line4: "line4",
      line5: "line5",
      postcode: "postcode",
      phone: "phone",
      email: "email"
    }
  end
end
