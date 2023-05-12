class Contact::Project < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project

end
