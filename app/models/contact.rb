class Contact < ApplicationRecord
  self.table_name = :contacts

  validates :category, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  enum category: {
    school_or_academy: 1,
    incoming_trust: 2,
    outgoing_trust: 6,
    local_authority: 3,
    solicitor: 5,
    diocese: 4,
    member_of_parliament: 7,
    other: 0
  }

  scope :by_name, -> { order(:name) }

  def editable?
    true
  end
end
