module TaskListHelper
  def task_status_id(task)
    "#{task.title.parameterize}-status"
  end

  def task_status_tag(task)
    tags_for_states = {
      unknown: {
        text: "Unknown",
        colour: "grey"
      }
    }

    task_state = tags_for_states.fetch(task.status, tags_for_states[:unknown])

    govuk_tag(
      text: task_state[:text],
      colour: task_state[:colour],
      classes: "app-task-list__tag",
      html_attributes: {id: task_status_id(task)}
    )
  end
end
