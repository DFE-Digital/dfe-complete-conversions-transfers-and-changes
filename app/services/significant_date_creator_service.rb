class SignificantDateCreatorService
  def initialize(project:, revised_date:, note_body:, user:)
    @project = project
    @previous_date = @project.significant_date
    @revised_date = revised_date
    @user = user
    @note_body = note_body
  end

  def update!
    ActiveRecord::Base.transaction do
      date_history_note = Note.create!(project_id: @project.id, user_id: @user.id, body: @note_body)
      date_history = SignificantDateHistory.create!(project_id: @project.id, previous_date: @previous_date, revised_date: @revised_date, note: date_history_note)
      @project.update!(significant_date: @revised_date, significant_date_provisional: false)

      raise ActiveRecord::RecordInvalid unless date_history_note.persisted? && @project.persisted? && date_history.persisted?
    rescue ActiveRecord::RecordInvalid
      return false
    end

    true
  end
end
