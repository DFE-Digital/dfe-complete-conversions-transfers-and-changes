class Task < ApplicationRecord
  belongs_to :section
  has_many :actions, dependent: :destroy

  default_scope { order(order: "asc") }

  delegate :project, to: :section

  def status
    :unknown
  end
end
