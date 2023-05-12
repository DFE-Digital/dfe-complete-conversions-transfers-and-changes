class Contact::DirectorOfChildServices < Contact::Base
  belongs_to :local_authority

  attribute :category, default: 3

  def organisation_name
    local_authority.name
  end
end
