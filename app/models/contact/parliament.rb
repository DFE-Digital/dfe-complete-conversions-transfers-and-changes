class Contact::Parliament < Contact
  def self.policy_class
    ContactPolicy
  end

  attribute :category, default: 7
  attribute :organisation_name, default: "HM Government"

  validates :parliamentary_constituency, presence: true

  def editable?
    false
  end

  def title
    I18n.t("members_api.member.title", constituency: parliamentary_constituency&.titleize)
  end
end
