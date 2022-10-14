class ProjectsCloseController < ApplicationController
  def close
    @project = Project.find(project_id)
    set_project_closed_at

    render :closed
  end

  private def set_project_closed_at
    return if @project.closed?

    @project.update!(closed_at: DateTime.now)
  end

  private def project_id
    params[:project_id]
  end
end
