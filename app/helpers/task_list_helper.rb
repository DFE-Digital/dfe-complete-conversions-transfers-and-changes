module TaskListHelper
  def task_status_id(task)
    "#{task.title.parameterize}-status"
  end
end
