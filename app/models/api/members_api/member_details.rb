class Api::MembersApi::MemberDetails
  def initialize(member_name, member_contact_details)
    @member_name = member_name
    @member_contact_details = member_contact_details
  end

  def name
    @member_name&.name_display_as
  end

  def email
    @member_contact_details&.email
  end

  def address
    OpenStruct.new(
      line1: address_lines[0],
      line2: address_lines[1],
      line3: address_lines[2],
      postcode: address_postcode
    )
  end

  private def address_lines
    all_address_lines = [
      @member_contact_details&.line1,
      @member_contact_details&.line2,
      @member_contact_details&.line3,
      @member_contact_details&.line4,
      @member_contact_details&.line5
    ]

    all_address_lines.compact_blank
  end

  private def address_postcode
    @member_contact_details&.postcode
  end
end
