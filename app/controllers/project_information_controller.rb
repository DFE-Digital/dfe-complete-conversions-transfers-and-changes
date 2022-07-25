class ProjectInformationController < ApplicationController
  include Authentication

  def show
    @project = Project.find(params[:id])
  end
end
