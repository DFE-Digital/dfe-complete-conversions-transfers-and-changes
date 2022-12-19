class Conversion::Voluntary::TaskListsController < TaskListsController
  def task_edit_path(task)
    conversion_voluntary_task_path(@project.id, task.class.identifier)
  end
  helper_method :task_edit_path

  def task_template_path(task_identifier)
    "conversion/voluntary/task_lists/tasks/#{task_identifier}"
  end
end
