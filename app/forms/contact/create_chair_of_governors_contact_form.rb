class Contact::CreateChairOfGovernorsContactForm < Contact::CreateProjectContactForm
  def category
    "school_or_academy"
  end

  def title
    "Chair of governors"
  end

  def organisation_name
    @project.establishment&.name
  end
end
