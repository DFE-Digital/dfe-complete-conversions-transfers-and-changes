module ExternalContactsHelper
  def has_contacts?(contacts)
    contacts.present? && contacts.any?
  end
end
