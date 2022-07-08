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
    workflow["sections"].each_with_index do |workflow_section, index|
      section = Section.create(title: workflow_section["title"], order: index, project: project)

      workflow_section["tasks"].each_with_index do |workflow_task, index|
        Task.create(title: workflow_task["title"], order: index, section: section)
      end
    end
  end
end
