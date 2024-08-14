class Contact < ApplicationRecord
  self.table_name = :contacts

  validates :category, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  has_one :main_contact_for_project, class_name: "::Project", inverse_of: :main_contact
  has_one :main_contact_for_establishment, class_name: "::Project", inverse_of: :establishment_main_contact
  has_one :main_contact_for_incoming_trust, class_name: "::Project", inverse_of: :incoming_trust_main_contact
  has_one :main_contact_for_outgoing_trust, class_name: "::Project", inverse_of: :outgoing_trust_main_contact
  has_one :main_contact_for_local_authority, class_name: "::Project", inverse_of: :local_authority_main_contact
  has_one :contact_for_chair_of_governors, class_name: "::Project", inverse_of: :chair_of_governors_contact

  enum category: {
    school_or_academy: 1,
    incoming_trust: 2,
    outgoing_trust: 6,
    local_authority: 3,
    solicitor: 5,
    diocese: 4,
    other: 0
  }

  scope :by_name, -> { order(:name) }

  def editable?
    true
  end

  def email_and_phone
    "#{email}, #{phone}"
  end
end
