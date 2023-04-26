class Conversions::TasksController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @task_list = Conversion::TaskList.new(@project, current_user)
  end
end
