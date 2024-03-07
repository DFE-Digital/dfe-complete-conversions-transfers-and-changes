class ContactsFetcherService
  def all_project_contacts(project)
    project_contacts = project.contacts
    all_contacts = project_contacts.to_a

    director_of_child_services = project.director_of_child_services
    all_contacts << director_of_child_services unless director_of_child_services.nil?

    establishment_contacts = Contact::Establishment.find_by(establishment_urn: project.urn)
    all_contacts << establishment_contacts unless establishment_contacts.nil?

    return {} unless all_contacts.any?

    all_contacts.sort_by(&:name).group_by(&:category)
  end

  def school_or_academy_contact(project)
    contacts = ContactsFetcherService.new.all_project_contacts(project)
    return if contacts["school_or_academy"].blank?

    if project.establishment_main_contact_id.present?
      contacts["school_or_academy"].find { |c| c.id == project.establishment_main_contact_id }
    else
      contacts["school_or_academy"].first
    end
  end

  def outgoing_trust_contact(project)
    contacts = ContactsFetcherService.new.all_project_contacts(project)
    return if contacts["outgoing_trust"].blank?

    if project.outgoing_trust_main_contact_id.present?
      contacts["outgoing_trust"].find { |c| c.id == project.outgoing_trust_main_contact_id }
    else
      contacts["outgoing_trust"].first
    end
  end

  def incoming_trust_contact(project)
    contacts = ContactsFetcherService.new.all_project_contacts(project)
    return if contacts["incoming_trust"].blank?

    if project.incoming_trust_main_contact_id.present?
      contacts["incoming_trust"].find { |c| c.id == project.incoming_trust_main_contact_id }
    else
      contacts["incoming_trust"].first
    end
  end

  def other_contact(project)
    contacts = ContactsFetcherService.new.all_project_contacts(project)
    return if contacts["other"].blank?

    contacts["other"].first
  end
end
