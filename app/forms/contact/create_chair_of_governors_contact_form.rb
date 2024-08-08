class Contact::CreateChairOfGovernorsContactForm < Contact::CreateProjectContactForm
  def save
    @contact.assign_attributes(category: :school_or_academy,
      name: name,
      title: "Chair of Governors",
      organisation_name: @project.establishment&.name,
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
