class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project))
  end

  def show
    @project = Project.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end

  def new
    authorize Project
    @project_form = ProjectForm.new
  end

  def create
    authorize Project
    @project_form = ProjectForm.new(**project_params, regional_delivery_officer_id: user_id)
    @note_form = NoteForm.new(**note_params, user_id:)

    project = ProjectCreator.new.call(@project_form, @note_form)
    if project
      redirect_to project_path(project), notice: I18n.t("project.create.success")
    else
      render :new
    end
  end

  private def project_params
    params.require(:project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :target_completion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :trust_sharepoint_link
    )
  end

  private def note_params
    params.require(:project_form).require(:note).permit(:body)
  end
end
