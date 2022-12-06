class Conversion::Voluntary::TasksController < ApplicationController
  def index
    @task_list = Conversion::Voluntary::TaskList.new
    @sections = @task_list.sections
  end

  def show
    section_slug = params["section_slug"]
    task_slug = params["task_slug"]
    render "conversion/voluntary/tasks/#{section_slug}/#{task_slug}"
  end

end
