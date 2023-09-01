class Contact < ApplicationRecord
  self.table_name = :contacts

  validates :category, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  scope :by_name, -> { order(:name) }

  enum category: {
    school: 1,
    incoming_trust: 2,
    outgoing_trust: 6,
    local_authority: 3,
    solicitor: 5,
    diocese: 4,
    other: 0
  }







end
