class Contact::Project < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project, optional: true

  def establishment_main_contact
    return false unless project_id
    project = ::Project.find(project_id)
    project&.establishment_main_contact_id.eql?(id)
  end

  def incoming_trust_main_contact
    return false unless project_id
    project = ::Project.find(project_id)
    project&.incoming_trust_main_contact_id.eql?(id)
  end

  def outgoing_trust_main_contact
    return false unless project_id
    project = ::Project.find(project_id)
    project&.outgoing_trust_main_contact_id.eql?(id)
  end
end
