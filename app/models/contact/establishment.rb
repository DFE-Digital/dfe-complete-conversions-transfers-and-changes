class Contact::Establishment < Contact
  def self.policy_class
    ContactPolicy
  end

  validates :establishment_urn, presence: true

  attribute :category, default: 1

  def establishment
    Gias::Establishment.find_by(urn: establishment_urn)
  end

  def editable?
    false
  end
end
