module Export::Csv::ChairOfGovernorsPresenterModule
  def chair_of_governors_name
    return if @project.chair_of_governors_contact.nil?

    @project.chair_of_governors_contact.name
  end

  def chair_of_governors_email
    return if @project.chair_of_governors_contact.nil?

    @project.chair_of_governors_contact.email
  end
end
