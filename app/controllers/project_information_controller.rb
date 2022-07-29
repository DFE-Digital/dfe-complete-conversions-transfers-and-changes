class ProjectInformationController < ApplicationController
  def show
    @project = Project.find(params[:id])
  end
end
