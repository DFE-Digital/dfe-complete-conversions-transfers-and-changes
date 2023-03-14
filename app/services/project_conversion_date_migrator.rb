class ProjectConversionDateMigrator
  def initialize(project)
    @project = project
  end

  def migrate_up!
    if @project.conversion_date.nil? && @project.conversion_date_provisional? && @project.task_list.stakeholder_kick_off_confirmed_conversion_date.nil?
      @project.update!(conversion_date: @project.provisional_conversion_date)
    else
      note_body = "Conversion date confirmed as part of external stakeholder kick off task."

      user = if @project.assigned_to.present?
        User.find(@project.assigned_to.id)
      else
        User.find(@project.regional_delivery_officer.id)
      end

      conversion_date_history_note = Note.create!(project_id: @project.id, user_id: user.id, body: note_body)
      Conversion::DateHistory.create!(project_id: @project.id, previous_date: @project.provisional_conversion_date, revised_date: @project.conversion_date, note: conversion_date_history_note)
      @project.update!(conversion_date_provisional: false)
    end
  end
end
