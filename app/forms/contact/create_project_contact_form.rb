class Contact::CreateProjectContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :category
  attribute :name
  attribute :title
  attribute :organisation_name
  attribute :email
  attribute :phone
  attribute :establishment_main_contact
  attribute :incoming_trust_main_contact
  attribute :outgoing_trust_main_contact
  attribute :project_id
  attr_accessor :category,
    :name,
    :title,
    :organisation_name,
    :email,
    :phone,
    :establishment_main_contact,
    :incoming_trust_main_contact,
    :outgoing_trust_main_contact,
    :project_id

  validate :establishment_main_contact_for_school_only, if: -> { establishment_main_contact.eql?("1") }
  validate :incoming_trust_main_contact_for_incoming_trust_only, if: -> { incoming_trust_main_contact.eql?("1") }
  validate :outgoing_trust_main_contact_for_outgoing_trust_only, if: -> { outgoing_trust_main_contact.eql?("1") }

  def initialize(args = {}, project = nil, contact = nil)
    @project = project
    @contact = contact
    super(args)
  end

  def self.new_from_contact(args = {}, project, contact)
    @project = project
    @contact = contact

    new({category: contact.category,
         name: contact.name,
         title: contact.title,
         organisation_name: contact.organisation_name,
         email: contact.email,
         phone: contact.phone,
         establishment_main_contact: contact.establishment_main_contact,
         incoming_trust_main_contact: contact.incoming_trust_main_contact,
         outgoing_trust_main_contact: contact.outgoing_trust_main_contact},
      @project,
      @contact)
  end

  def save
    @contact ||= Contact::Project.new
    @contact.assign_attributes(category: category,
      name: name,
      title: title,
      organisation_name: organisation_name,
      email: email,
      phone: phone,
      project_id: @project.id)

    if valid? && @contact.valid?
      ActiveRecord::Base.transaction do
        @contact.save
        set_establishment_main_contact
        set_incoming_trust_main_contact
        set_outgoing_trust_main_contact
      end
    else
      errors.merge!(@contact.errors)
      nil
    end
  end

  private def establishment_main_contact_for_school_only
    return true if category.eql?("school")
    errors.add(:establishment_main_contact, :invalid)
  end

  private def incoming_trust_main_contact_for_incoming_trust_only
    return true if category.eql?("incoming_trust")
    errors.add(:incoming_trust_main_contact, :invalid)
  end

  private def outgoing_trust_main_contact_for_outgoing_trust_only
    return true if category.eql?("outgoing_trust")
    errors.add(:outgoing_trust_main_contact, :invalid)
  end

  private def set_establishment_main_contact
    project = @project || Project.find(@contact.project_id)

    if establishment_main_contact == "1"
      project.update!(establishment_main_contact_id: @contact.id)
    else
      project.update!(establishment_main_contact_id: nil)
    end
  end

  private def set_incoming_trust_main_contact
    project = @project || Project.find(@contact.project_id)

    if incoming_trust_main_contact == "1"
      project.update!(incoming_trust_main_contact_id: @contact.id)
    else
      project.update!(incoming_trust_main_contact_id: nil)
    end
  end

  private def set_outgoing_trust_main_contact
    project = @project || Project.find(@contact.project_id)

    if outgoing_trust_main_contact == "1"
      project.update!(outgoing_trust_main_contact_id: @contact.id)
    else
      project.update!(outgoing_trust_main_contact_id: nil)
    end
  end
end
