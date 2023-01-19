class Contact < ApplicationRecord
  belongs_to :project

  validates :category, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true

  enum category: {
    diocese: 4,
    local_authority: 3,
    school: 1,
    solicitor: 5,
    trust: 2,
    other: 0
  }

  scope :grouped_by_category, -> { order(:name, category: :desc).group_by(&:category) }
end
