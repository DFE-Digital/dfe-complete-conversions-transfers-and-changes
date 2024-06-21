class Api::MembersApi::MemberContactDetails < Api::BaseApiModel
  attr_accessor(
    :line1,
    :line2,
    :postcode,
    :phone,
    :email
  )

  def self.attribute_map
    {
      phone: "phone",
      email: "email"
    }
  end

  def line1
    "House of Commons"
  end

  def line2
    "London"
  end

  def postcode
    "SW1A 0AA"
  end

  def address
    [
      line1,
      line2,
      postcode
    ]
  end
end
