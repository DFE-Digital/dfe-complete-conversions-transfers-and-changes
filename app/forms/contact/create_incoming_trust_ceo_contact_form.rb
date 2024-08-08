class Contact::CreateIncomingTrustCeoContactForm < Contact::CreateProjectContactForm
  def save
    @contact.assign_attributes(category: :incoming_trust,
      name: name,
      title: "CEO",
      organisation_name: @project.incoming_trust&.name,
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
end
