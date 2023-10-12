class Contact::Establishment < Contact
  def self.policy_class
    ContactPolicy
  end

  validates :establishment_urn, presence: true

  def establishment
    Gias::Establishment.find_by(urn: establishment_urn)
  end

  def editable?
    false
  end
end
