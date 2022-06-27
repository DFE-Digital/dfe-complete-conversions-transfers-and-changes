class ProjectController < ApplicationController
  include Authentication

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.valid?
      @project.save
      flash[:notice] = I18n.t("project.create.success")
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:urn)
  end
end
