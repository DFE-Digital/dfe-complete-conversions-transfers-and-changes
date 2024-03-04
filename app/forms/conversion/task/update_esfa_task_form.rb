class Conversion::Task::UpdateEsfaTaskForm < BaseTaskForm
  attribute :update, :boolean

  private def in_progress?
    update.present? || task_notes.any?
  end

  private def completed?
    update.present? && task_notes.any?
  end

  private def task_notes
    @tasks_data.project.notes.select do |note|
      note.task_identifier.eql?(identifier.to_s)
    end
  end
end
