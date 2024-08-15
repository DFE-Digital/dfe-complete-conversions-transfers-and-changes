module Export::Csv::ChairOfGovernorsPresenterModule
  def chair_of_governors_name
    return unless @project.key_contacts&.chair_of_governors.present?

    @project.key_contacts.chair_of_governors.name
  end

  def chair_of_governors_email
    return unless @project.key_contacts&.chair_of_governors.present?

    @project.key_contacts.chair_of_governors.email
  end
end
