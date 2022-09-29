class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :task, optional: true

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }
end
