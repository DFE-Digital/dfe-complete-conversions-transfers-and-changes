class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :conversion_date_history, class_name: "Conversion::DateHistory", optional: true

  validates :body, presence: true, allow_blank: false

  default_scope { order(created_at: "desc") }

  scope :project_level_notes, ->(project) { where(task_identifier: nil).and(where(project: project)) }

  # When no value is provided, Rails will store an empty string. Instead, we want to ensure
  # these are stored as NULL, so that we aren't mixing blanks and NULLs.
  def task_identifier=(value)
    write_attribute(:task_identifier, value) if value.present?
  end

  def task_level_note?
    task_identifier.present?
  end
end
