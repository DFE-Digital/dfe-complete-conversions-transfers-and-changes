class TaskListCreator
  DEFAULT_ACTION_TYPE = "single-checkbox".freeze

  def call(project, workflow_root:)
    workflow = load_workflow_tasklist_from_root(workflow_root)

    workflow.fetch("sections").each_with_index do |section_name, index|
      section_data = load_workflow_section_from_root(workflow_root, section_name)
      section = Section.create(title: section_data.fetch("title"), order: index, project: project)
      create_tasks_in_section(section_data, section)
    end
  end

  private def load_workflow_tasklist_from_root(workflow_root)
    YAML.load_file(File.join(workflow_root, "tasklist.yml"))
  end

  private def load_workflow_section_from_root(workflow_root, section)
    YAML.load_file(Rails.root.join(workflow_root, "sections", "#{section}.yml"))
  end

  private def create_tasks_in_section(section_data, section)
    section_data.fetch("tasks").each_with_index do |task_data, index|
      task = Task.create(
        slug: task_data.fetch("slug"),
        title: task_data.fetch("title"),
        hint: task_data.fetch("hint", nil),
        guidance_summary: task_data.fetch("guidance_summary", nil),
        guidance_text: task_data.fetch("guidance_text", nil),
        order: index,
        section: section,
        optional: task_data.fetch("optional", false)
      )

      create_actions_in_task(task_data, task)
    end
  end

  private def create_actions_in_task(task_data, task)
    task_data.fetch("actions").each_with_index do |action_data, index|
      action_data["action_type"] = action_data.delete("type") { |t| DEFAULT_ACTION_TYPE }
      Action.create(action_data.merge({order: index, task_id: task.id}))
    end
  end
end
