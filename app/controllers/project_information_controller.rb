class ProjectInformationController < ApplicationController
  include Projectable

  def show
    @project = Project.find(params[:project_id])
  end
end
