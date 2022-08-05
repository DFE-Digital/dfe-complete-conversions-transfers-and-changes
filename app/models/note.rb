class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }
end
