module TaskListHelper
  def task_status_id(task)
    "#{task.title.parameterize}-status"
  end

  def task_status_tag(task)

    govuk_tag(text: 'Completed', classes: "app-task-list__tag", html_attributes: {id: task_status_id(task)})
  end
end
