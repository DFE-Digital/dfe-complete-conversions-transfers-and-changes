class TaskListCreator
  WORKFLOW_NAME = "conversion".freeze

  def call(project)
    workflow = load_workflow
    create_task_list_from_workflow(project, workflow)
  end

  private def load_workflow
    YAML.load_file(Rails.root.join("app", "workflows", "#{WORKFLOW_NAME}.yml"))
  end

  private def create_task_list_from_workflow(project, workflow)
    workflow.fetch("sections").each_with_index do |workflow_section, index|
      section = Section.create(title: workflow_section.fetch("title"), order: index, project: project)

      workflow_section.fetch("tasks").each_with_index do |workflow_task, index|
        task = Task.create(
          title: workflow_task.fetch("title"),
          hint: workflow_task.fetch("hint", nil),
          guidance_summary: workflow_task.fetch("guidance_summary", nil),
          guidance_text: workflow_task.fetch("guidance_text", nil),
          order: index,
          section: section,
          optional: workflow_task.fetch("optional", false)
        )

        create_actions(workflow_task, task)
      end
    end
  end

  private def create_actions(workflow_task, task)
    workflow_task.fetch("actions").each_with_index do |workflow_action, index|
      Action.create(workflow_action.merge({order: index, task_id: task.id}))
    end
  end
end
