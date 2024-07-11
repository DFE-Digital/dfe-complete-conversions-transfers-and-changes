class Contact::Parliament
  def self.policy_class
    ContactPolicy
  end

  validates :constituency_id, presence: true

  attribute :category, default: 7

  def editable?
    false
  end

  def title
    I18n.t("members_api.member.title")
  end

  def phone
    nil
  end

  def organisation_name
    I18n.t("members_api.member.organisation")
  end
end
