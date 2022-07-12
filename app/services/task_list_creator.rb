class TaskListCreator
  WORKFLOW_NAME = "conversion".freeze

  def call(project)
    workflow = load_workflow
    create_task_list_from_workflow(project, workflow)
  end

  private def load_workflow
    YAML.load_file("workflows/#{WORKFLOW_NAME}.yml")
  end

  private def create_task_list_from_workflow(project, workflow)
    workflow.fetch("sections").each_with_index do |workflow_section, index|
      section = Section.create(title: workflow_section.fetch("title"), order: index, project: project)

      workflow_section.fetch("tasks").each_with_index do |workflow_task, index|
        task = Task.create(title: workflow_task.fetch("title"), order: index, section: section)

        create_actions(workflow_task, task)
      end
    end
  end

  private def create_actions(workflow_task, task)
    all_actions = []
    workflow_task.fetch("actions").each_with_index do |workflow_action, index|
      all_actions << workflow_action.merge({order: index, task_id: task.id})
    end

    Action.insert_all(all_actions) unless all_actions.empty?
  end
end
