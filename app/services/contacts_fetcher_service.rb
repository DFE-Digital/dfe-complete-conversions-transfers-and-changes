class ContactsFetcherService
  attr_reader :director_of_child_services

  def initialize(project)
    @project = project
    @project_contacts = @project.contacts
    @establishment_contacts = Contact::Establishment.find_by(establishment_urn: @project.urn)
    @all_contacts = all_project_contacts_grouped
    @director_of_child_services = @project.director_of_child_services
  end

  def all_project_contacts_grouped
    all_contacts = @project_contacts.to_a

    all_contacts << @director_of_child_services unless @director_of_child_services.nil?

    establishment_contacts = @establishment_contacts
    all_contacts << establishment_contacts unless establishment_contacts.nil?

    return {} unless all_contacts.any?

    all_contacts.sort_by(&:name).group_by(&:category)
  end

  def school_or_academy_contact
    return if @all_contacts["school_or_academy"].nil?

    if @project.establishment_main_contact_id.present?
      @all_contacts["school_or_academy"].find { |c| c.id == @project.establishment_main_contact_id }
    else
      @all_contacts["school_or_academy"].in_order_of(:type, %w[Contact::Establishment Contact::Project]).first
    end
  end

  def outgoing_trust_contact
    return if @all_contacts["outgoing_trust"].nil?

    if @project.outgoing_trust_main_contact_id.present?
      @all_contacts["outgoing_trust"].find { |c| c.id == @project.outgoing_trust_main_contact_id }
    else
      @all_contacts["outgoing_trust"].first
    end
  end

  def incoming_trust_contact
    return if @all_contacts["incoming_trust"].nil?

    if @project.incoming_trust_main_contact_id.present?
      @all_contacts["incoming_trust"].find { |c| c.id == @project.incoming_trust_main_contact_id }
    else
      @all_contacts["incoming_trust"].first
    end
  end

  def other_contact
    return if @all_contacts["other"].nil?

    @all_contacts["other"].first
  end
end
