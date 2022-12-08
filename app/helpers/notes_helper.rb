module NotesHelper
  def has_notes?(notes)
    notes.present? && notes.any?
  end

  def back_link_destination(note)
    # return project_task_path(note.project, note.task) if note.task_level_note?

    project_notes_path(note.project)
  end
end
