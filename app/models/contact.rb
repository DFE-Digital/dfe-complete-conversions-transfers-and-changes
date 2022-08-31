class Contact < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  enum category: {
    other: 0,
    school: 1,
    trust: 2,
    local_authority: 3,
    diocese: 4
  }
end
