module ContactsHelper
  def has_contacts?(contacts)
    contacts.present? && contacts.any?
  end

  def category_header(category, project)
    case category
    when "school_or_academy"
      I18n.t("contact.index.category_heading", category_name: project.establishment.name)
    when "incoming_trust"
      I18n.t("contact.index.category_heading", category_name: project.incoming_trust.name)
    when "outgoing_trust"
      I18n.t("contact.index.category_heading", category_name: project.outgoing_trust&.name)
    when "local_authority"
      I18n.t("contact.index.category_heading", category_name: project.local_authority&.name)
    else
      I18n.t("contact.index.category_heading", category_name: category.humanize)
    end
  end

  def primary_contact_at_organisation(contact, category)
    return unless contact.is_a?(Contact::Project)

    case category
    when "school_or_academy"
      contact.establishment_main_contact ? I18n.t("yes") : I18n.t("no")
    when "local_authority"
      contact.local_authority_main_contact ? I18n.t("yes") : I18n.t("no")
    when "incoming_trust"
      contact.incoming_trust_main_contact ? I18n.t("yes") : I18n.t("no")
    when "outgoing_trust"
      contact.outgoing_trust_main_contact ? I18n.t("yes") : I18n.t("no")
    else
      I18n.t("no")
    end
  end

  def has_primary_contact?(category)
    return true if %w[school_or_academy incoming_trust outgoing_trust local_authority].include?(category)
    false
  end
end
