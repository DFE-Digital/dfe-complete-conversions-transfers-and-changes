class ProjectInformationController < ApplicationController
  def show
    @project = ProjectPresenter.new(ConversionProject.find(params[:conversion_project_id]))
  end
end
