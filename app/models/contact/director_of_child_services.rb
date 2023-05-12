class Contact::DirectorOfChildServices < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :local_authority

  attribute :category, default: 3

  def organisation_name
    local_authority.name
  end
end
