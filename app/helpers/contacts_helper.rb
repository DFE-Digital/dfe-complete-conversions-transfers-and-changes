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
end
