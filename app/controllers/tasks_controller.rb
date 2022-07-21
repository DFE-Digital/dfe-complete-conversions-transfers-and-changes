class TasksController < ApplicationController
  def show
    @task = Task.joins(:section).where(section: { project: params[:project_id] }).find(params[:id])
  end
end
