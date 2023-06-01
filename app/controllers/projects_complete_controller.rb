class ProjectsCompleteController < ApplicationController
  def complete
    @project = Project.find(project_id)
    authorize @project, :update?

    set_project_completed_at

    render :completed
  end

  private def project_completable?
    return true if @project.all_conditions_met? && @project.conversion_date_confirmed_and_passed? && @project.grant_payment_certificate_received?
    false
  end

  private def set_project_completed_at
    return if @project.completed?

    @project.update!(completed_at: DateTime.now)
  end

  private def project_id
    params[:project_id]
  end
end
