class ProjectsController < ApplicationController
  include Authentication
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Project
    @projects = policy_scope(Project).includes([:delivery_officer])
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
    @project = Project.new(project_params)
    authorize @project
    assign_team_leader

    if @project.valid?
      @project.save
      flash[:notice] = I18n.t("project.create.success")
      TaskListCreator.new.call(@project)

      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project

    @users = User.all
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    @project.assign_attributes(project_params)

    @project.save
    flash[:notice] = I18n.t("project.update.success")
    redirect_to project_information_path(@project)
  end

  private def project_params
    params.require(:project).permit(:urn, :delivery_officer_id)
  end

  private def assign_team_leader
    @project.team_leader_id = user_id
  end
end
