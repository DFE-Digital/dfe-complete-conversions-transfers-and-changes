class Note < ApplicationRecord
  belongs_to :conversion_project
  belongs_to :user
  belongs_to :task, optional: true
  alias_attribute :project, :conversion_project

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }

  scope :project_level_notes, ->(project) { where(task: nil).and(where(project: project)) }

  def task_level_note?
    task.present?
  end
end
