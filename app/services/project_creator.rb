class ProjectCreator
  DEFAULT_WORKFLOW_ROOT = Rails.root.join("app", "workflows", "lists", "conversion").freeze

  def call(project_form, note_form)
    return false if invalid?(project_form, note_form)

    ActiveRecord::Base.transaction do
      @project = project_form.create
      create_note(note_form, @project)

      TaskListCreator.new.call(@project, workflow_root: DEFAULT_WORKFLOW_ROOT)
    end

    notify_team_leaders(@project)

    @project
  end

  private def invalid?(project_form, note_form)
    project_invalid = project_form.invalid?
    note_invalid = note_form.body.present? && note_form.invalid?

    project_invalid || note_invalid
  end

  private def create_note(note_form, project)
    return false unless note_form.body.present?

    note_form.assign_attributes(project:)
    note_form.create
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_project_created(team_leader, project).deliver_later
    end
  end
end
