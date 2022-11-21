module NotesHelper
  def has_notes?(notes)
    notes.present? && notes.any?
  end

  def back_link_destination(note)
    return conversion_project_task_path(note.conversion_project, note.task) if note.task_level_note?

    conversion_project_notes_path(note.conversion_project)
  end
end
