module Flow
  extend ActiveSupport::Concern

  def self.load_flow(name)
    flow_definition = YAML.load_file("flows/#{name}.yml")

    # We perform a bit of a gnarly iteration here, but it's the easiest way to both build out a structure for the task list and pull individual tasks into a way we can select them by key

    section_structure = []
    tasks = {}

    for section in flow_definition["sections"]
      section_structure.append(section)

      for task in section["tasks"]
        tasks[task["slug"]] = task
      end
    end

    {
      title: flow_definition["title"],
      description: GovukMarkdown.render(flow_definition["description"]),
      sections: section_structure,
      tasks: tasks
    }
  end
end
