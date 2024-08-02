class Contact::Project < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project, class_name: "::Project"

  def establishment_main_contact
    project.establishment_main_contact_id == id
  end

  def incoming_trust_main_contact
    project.incoming_trust_main_contact_id == id
  end

  def outgoing_trust_main_contact
    project.outgoing_trust_main_contact_id == id
  end

  def local_authority_main_contact
    project.local_authority_main_contact_id == id
  end
end
