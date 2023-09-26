class Contact::CreateProjectContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  CATEGORIES_WITH_PRIMARY_CONTACT = [
    "school_or_academy",
    "incoming_trust",
    "outgoing_trust"
  ].freeze

  attribute :category
  attribute :name
  attribute :title
  attribute :organisation_name
  attribute :email
  attribute :phone
  attribute :primary_contact_for_category, :boolean

  attr_accessor :category,
    :name,
    :title,
    :organisation_name,
    :email,
    :phone

  validate :category_with_primary_contact

  def initialize(contact:, project:, args: {})
    @project = project
    @contact = contact
    super(args)

    if args.empty?
      self.primary_contact_for_category = is_primary_contact_for_category?
      assign_attributes(
        category: @contact.category,
        name: @contact.name,
        title: @contact.title,
        organisation_name: @contact.organisation_name,
        email: @contact.email,
        phone: @contact.phone
      )
    end
  end

  def save
    @contact.assign_attributes(category: category,
      name: name,
      title: title,
      organisation_name: organisation_name,
      email: email,
      phone: phone,
      project_id: @project.id)

    if valid? && @contact.valid?
      ActiveRecord::Base.transaction do
        @contact.save!
        update_project_contact_associations
        @project.save!
      end
    else
      errors.merge!(@contact.errors)
      nil
    end
  end

  private def category_with_primary_contact
    return unless primary_contact_for_category

    errors.add(:primary_contact_for_category, :category) unless CATEGORIES_WITH_PRIMARY_CONTACT.include?(category)
  end

  private def is_primary_contact_for_category?
    case @contact.category
    when "school_or_academy"
      @contact.establishment_main_contact
    when "incoming_trust"
      @contact.incoming_trust_main_contact
    when "outgoing_trust"
      @contact.outgoing_trust_main_contact
    end
  end

  private def update_project_contact_associations
    case category
    when "school_or_academy"
      @project.establishment_main_contact_id = primary_contact_for_category ? @contact.id : nil
    when "incoming_trust"
      @project.incoming_trust_main_contact_id = primary_contact_for_category ? @contact.id : nil
    when "outgoing_trust"
      @project.outgoing_trust_main_contact_id = primary_contact_for_category ? @contact.id : nil
    end
  end
end
