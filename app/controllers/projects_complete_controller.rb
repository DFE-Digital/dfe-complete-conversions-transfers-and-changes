class ProjectsCompleteController < ApplicationController
  def complete
    @project = Project.find(project_id)
    authorize @project, :update?

    if project_completable?
      set_project_completed_at

      render :completed
    else
      flash[:alert] = I18n.t("project.complete.unable_to_complete_html")
      redirect_to project_tasks_path(@project)
    end
  end

  private def project_completable?
    return true if @project.all_conditions_met? && @project.confirmed_date_and_in_the_past? && @project.grant_payment_certificate_received?
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
