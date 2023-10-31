class Contact::Parliament
  attr_reader :name, :email

  def initialize(constituency:)
    client = Api::MembersApi::Client.new
    member = client.member_id(constituency)

    raise member.error if member.error.present?

    member_id = member.object
    member_name = client.member_name(member_id).object
    contact_details = client.member_contact_details(member_id).object.find { |details| details.type_id == 1 }

    details = Api::MembersApi::MemberDetails.new(member_name, contact_details)

    @constituency = constituency
    @name = details.name
    @email = details.email
  end

  def id
    nil
  end

  def editable?
    false
  end

  def category
    "other"
  end

  def title
    I18n.t("members_api.member.title", constituency: @constituency)
  end

  def phone
    nil
  end

  def organisation_name
    nil
  end
end
