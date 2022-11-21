class Section < ApplicationRecord
  belongs_to :conversion_project
  has_many :tasks, dependent: :destroy
  alias_attribute :project, :conversion_project

  default_scope { order(order: "asc") }
end
