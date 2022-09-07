class ProjectsController < ApplicationController
  before_action :find_regional_delivery_officers, only: %i[new create]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Project
    @projects = policy_scope(Project)
  end

  def show
    @project = Project.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end

  def new
    authorize Project
    @project = Project.new
  end

  def create
    @note = Note.new(**note_params, user_id: user_id)
    @project = Project.new(**project_params, regional_delivery_officer_id: user_id, notes_attributes: [@note.attributes])

    authorize @project

    if @project.valid?
      @project.save
      TaskListCreator.new.call(@project)

      redirect_to project_path(@project), notice: I18n.t("project.create.success")
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project

    @users = User.caseworkers
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    assign_caseworker(caseworker_id)
    assign_team_leader

    @project.save
    redirect_to project_information_path(@project), notice: I18n.t("project.update.success")
  end

  private def find_regional_delivery_officers
    @regional_delivery_officers = User.where(regional_delivery_officer: true)
  end

  private def project_params
    params.require(:project).permit(
      :urn,
      :trust_ukprn,
      :target_completion_date
    )
  end

  private def note_params
    params.require(:project).require(:note).permit(:body)
  end

  private def caseworker_id
    params.require(:project).permit(:caseworker_id)
  end

  private def assign_team_leader
    @project.team_leader_id = user_id
  end

  private def assign_caseworker(caseworker_id)
    @project.assign_attributes(caseworker_id)
    @project.assign_attributes(caseworker_assigned_at: DateTime.now) if @project.caseworker_assigned_at.nil?
  end
end
