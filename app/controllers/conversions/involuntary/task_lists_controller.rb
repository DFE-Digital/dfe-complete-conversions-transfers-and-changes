class Conversions::Involuntary::TaskListsController < TaskListsController
  def task_edit_path(task)
    conversions_involuntary_project_edit_task_path(@project.id, task.class.identifier)
  end
  helper_method :task_edit_path

  def task_list_path(project)
    conversions_involuntary_project_task_list_path(project)
  end
  helper_method :task_list_path

  def task_template_path(task_identifier)
    "conversions/involuntary/task_lists/tasks/#{task_identifier}"
  end

  private def find_project
    @project = Project.conversions_involuntary.find(params[:project_id])
  end
end
