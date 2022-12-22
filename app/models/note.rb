class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :task, optional: true

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }

  scope :project_level_notes, ->(project) { where(task: nil, task_identifier: nil).and(where(project: project)) }

  # TODO: Remove this and the foreign key along with any references when removing the old (YAML) task list.
  def deprecated_task_level_note?
    task.present?
  end

  def task_level_note?
    task_identifier.present?
  end
end
