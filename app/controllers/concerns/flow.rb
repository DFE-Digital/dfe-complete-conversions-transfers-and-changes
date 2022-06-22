module Flow
  extend ActiveSupport::Concern

  def self.load_flow(name)
    flow_definition = YAML.load_file("flows/#{name}.yml").deep_symbolize_keys

    section_structure = []

    flow_definition[:sections].each do |section|
      section_structure.append(section)
    end

    {
      title: flow_definition[:title],
      description: GovukMarkdown.render(flow_definition[:description]),
      sections: section_structure
    }
  end
end
