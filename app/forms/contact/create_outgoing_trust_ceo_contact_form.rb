class Contact::CreateOutgoingTrustCeoContactForm < Contact::CreateProjectContactForm

  validate :transfer_projects_only

  def save
    @contact.assign_attributes(category: :outgoing_trust,
      name: name,
      title: "CEO",
      organisation_name: @project.outgoing_trust&.name,
      email: email,
      phone: phone,
      project_id: @project.id)

    if valid? && @contact.valid?
      ActiveRecord::Base.transaction do
        @contact.save!
        update_project_contact_associations
        @project.save!
      end
    else
      errors.merge!(@contact.errors)
      nil
    end
  end

  def transfer_projects_only
    errors.add(:base, :wrong_project_type_for_category) unless @project.is_a?(Transfer::Project)
  end
end
