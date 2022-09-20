class TaskListCreator
  def call(project, workflow_root:)
    workflow = load_workflow_definition(workflow_root)

    workflow.fetch("sections").each_with_index do |section_name, index|
      section_data = load_workflow_section(workflow_root, section_name)

      section = Section.create(title: section_data.fetch("title"), order: index, project: project)

      section_data.fetch("tasks").each_with_index do |workflow_task, index|
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

  private def load_workflow_definition(workflow_root)
    YAML.load_file(File.join(workflow_root, "definition.yml"))
  end

  private def load_workflow_section(workflow_root, section)
    YAML.load_file(Rails.root.join(workflow_root, "sections", "#{section}.yml"))
  end

  private def create_actions(workflow_task, task)
    workflow_task.fetch("actions").each_with_index do |workflow_action, index|
      Action.create(workflow_action.merge({order: index, task_id: task.id}))
    end
  end
end
