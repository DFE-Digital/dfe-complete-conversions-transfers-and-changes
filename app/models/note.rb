class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :task, optional: true

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }

  scope :project_level_notes, -> { where(task: nil) }

  def task_level_note?
    task.present?
  end
end
