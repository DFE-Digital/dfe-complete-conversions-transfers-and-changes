class Section < ApplicationRecord
  belongs_to :project
  has_many :tasks, dependent: :destroy

  default_scope { order(order: "asc") }
end
