class ProjectConversionDateMigrator
  def initialize(project)
    @project = project
  end

  def migrate_up!
    if @project.provisional_conversion_date.present? && @project.conversion_date.nil? && @project.task_list.stakeholder_kick_off_confirmed_conversion_date.nil?
      @project.update!(conversion_date: @project.provisional_conversion_date, conversion_date_provisional: true)
    elsif @project.task_list.stakeholder_kick_off_confirmed_conversion_date.present?
      note_body = "Conversion date confirmed as part of external stakeholder kick off task."
      previous_date = @project.provisional_conversion_date
      revised_date = @project.task_list.stakeholder_kick_off_confirmed_conversion_date

      user = if @project.assigned_to.present?
        User.find(@project.assigned_to.id)
      else
        User.find(@project.regional_delivery_officer.id)
      end

      conversion_date_history_note = Note.create!(project_id: @project.id, user_id: user.id, body: note_body)
      Conversion::DateHistory.create!(project_id: @project.id, previous_date: previous_date, revised_date: revised_date, note: conversion_date_history_note)
      @project.update!(conversion_date: revised_date, conversion_date_provisional: false)
    end
  end
end
