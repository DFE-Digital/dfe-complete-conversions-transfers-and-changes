class ContactsFetcherService
  def all_project_contacts(project)
    project_contacts = project.contacts
    all_contacts = project_contacts.to_a

    director_of_child_services = project.director_of_child_services
    all_contacts << director_of_child_services unless director_of_child_services.nil?

    return {} unless all_contacts.any?

    all_contacts.sort_by(&:name).group_by(&:category)
  end
end