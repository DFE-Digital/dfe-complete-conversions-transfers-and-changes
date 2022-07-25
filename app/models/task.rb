class Task < ApplicationRecord
  belongs_to :section
  has_many :actions, dependent: :destroy

  default_scope { order(order: "asc") }

  delegate :project, to: :section

  def actions_count
    @actions_count ||= actions.all.count
  end

  def completed_actions_count
    @completed_actions_count ||= actions.where(completed: true).count
  end

  def status
    if completed_actions_count == 0
      :not_started
    elsif completed_actions_count == actions_count
      :completed
    elsif completed_actions_count < actions_count
      :in_progress
    end
  end
end
