class Action < ApplicationRecord
  belongs_to :task

  default_scope { order(order: "asc") }
end
