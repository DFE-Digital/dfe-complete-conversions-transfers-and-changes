module Export::Csv::DirectorOfChildServicesPresenterModule
  def director_of_child_services_name
    return unless @director_of_child_services.present?

    @director_of_child_services.name
  end

  def director_of_child_services_role
    return unless @director_of_child_services.present?

    @director_of_child_services.title
  end

  def director_of_child_services_email
    return unless @director_of_child_services.present?

    @director_of_child_services.email
  end
end
