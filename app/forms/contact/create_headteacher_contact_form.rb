class Contact::CreateHeadteacherContactForm < Contact::CreateProjectContactForm
  def category
    "school_or_academy"
  end

  def title
    "Headteacher"
  end

  def organisation_name
    @project.establishment&.name
  end
end
