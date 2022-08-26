module ContactsHelper
  def has_contacts?(contacts)
    contacts.present? && contacts.any?
  end

  def format_category_name(category)
    category.tr("_", " ").capitalize
  end
end
