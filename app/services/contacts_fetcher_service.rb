class ContactsFetcherService
  attr_reader :director_of_child_services

  def initialize(project)
    @project = project
    @project_contacts = @project.contacts
    @establishment_contacts = Contact::Establishment.find_by(establishment_urn: @project.urn)
    @director_of_child_services = @project.director_of_child_services
    @all_contacts = all_project_contacts_grouped
  end

  def all_project_contacts
    all_contacts = @project_contacts.to_a

    all_contacts << @director_of_child_services unless @director_of_child_services.nil?

    all_contacts.sort_by(&:name)
  end

  def all_project_contacts_grouped
    return {} unless all_project_contacts.any?

    all_project_contacts.sort_by(&:name).group_by(&:category)
  end

  def school_or_academy_contact
    return if @all_contacts["school_or_academy"].nil?

    if @project.establishment_main_contact_id.present?
      @all_contacts["school_or_academy"].find { |c| c.id == @project.establishment_main_contact_id }
    else
      @all_contacts["school_or_academy"].first
    end
  end

  def local_authority_contact
    return if @all_contacts["local_authority"].nil?

    if @project.local_authority_main_contact_id.present?
      @all_contacts["local_authority"].find { |c| c.id == @project.local_authority_main_contact_id }
    else
      @all_contacts["local_authority"].first
    end
  end

  def other_contact
    return if @all_contacts["other"].nil?

    @all_contacts["other"].first
  end
end
