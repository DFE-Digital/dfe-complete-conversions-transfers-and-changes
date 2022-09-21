class ProjectInformationController < ApplicationController
  def show
    @project = ProjectPresenter.new(Project.find(params[:project_id]))
  end
end
