class Contact::Project < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project, optional: true
  validate :establishment_main_contact_for_school_only

  def establishment_main_contact
    return unless project_id
    project = ::Project.find(project_id)
    return false if project&.establishment_main_contact_id.eql?(nil)
    project&.establishment_main_contact_id.eql?(id)
  end

  private def establishment_main_contact_for_school_only
    return true if establishment_main_contact.eql?(false)
    return true if category.eql?("school")
    errors.add(:establishment_main_contact, :invalid)
  end
end
