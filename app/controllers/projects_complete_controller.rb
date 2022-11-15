class ProjectsCompleteController < ApplicationController
  def complete
    @project = Project.find(project_id)
    set_project_completed_at

    render :completed
  end

  private def set_project_completed_at
    return if @project.completed?

    @project.update!(completed_at: DateTime.now)
  end

  private def project_id
    params[:project_id]
  end
end
