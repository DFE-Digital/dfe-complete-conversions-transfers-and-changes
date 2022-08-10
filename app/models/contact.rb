class Contact < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true
end
