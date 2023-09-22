class Contact::DirectorOfChildServices < Contact
  def self.policy_class
    LocalAuthorityPolicy
  end

  belongs_to :local_authority, optional: true

  attribute :category, default: 3

  def organisation_name
    local_authority.name
  end

  def editable?
    false
  end
end
