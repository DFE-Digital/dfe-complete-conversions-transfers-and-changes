class ConversionDateUpdater
  def initialize(project:, revised_date:, note_body:, user:)
    @project = project
    @previous_date = project.conversion_date
    @revised_date = revised_date
    @user = user
    @note_body = note_body
  end

  def update!
    ActiveRecord::Base.transaction do
      conversion_date_history_note = Note.create!(project_id: @project.id, user_id: @user.id, body: @note_body)
      date_history = Conversion::DateHistory.create!(project_id: @project.id, previous_date: @previous_date, revised_date: @revised_date, note: conversion_date_history_note)
      @project.update!(conversion_date: @revised_date, conversion_date_provisional: false)

      raise ActiveRecord::RecordInvalid unless conversion_date_history_note.persisted? && @project.persisted? && date_history.persisted?
    rescue ActiveRecord::RecordInvalid
      return false
    end

    true
  end
end
