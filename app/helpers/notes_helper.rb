module NotesHelper
  def has_notes?(notes)
    notes.present? && notes.any?
  end
end
