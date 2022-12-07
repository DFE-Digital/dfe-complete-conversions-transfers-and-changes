class Conversion::Voluntary::TaskList
  SECTIONS = [
    {title: "Section one", tasks: [
      {title: "Task one", optional: false, actions: [
        :action_one_for_task_one_in_section_one,
        :action_two_for_task_one_in_section_one
      ], details: [
        :detail_one_for_task_one_in_section_two
      ]},
    ]},
    {title: "Section two"},
    {title:  "Section three"},
    {title: "Section four"}
  ]

  attr_reader :sections

  def initialize(project)
    @details = project.details
    @sections = SECTIONS.map { |section| Section.new(section) }
  end

  class Section
    attr_reader :title, :slug, :tasks

    def initialize(hash)
      @title = hash.fetch(:title)
      @slug = @title.to_s.parameterize
      @tasks = hash.fetch(:tasks, []).map { |task| Task.new(task) }
    end
  end

  class Task
    attr_reader :title, :slug, :optional, :actions, :details

    def initialize(hash)
      @title = hash.fetch(:title)
      @slug = @title.to_s.parameterize
      @optional = hash.fetch(:optional)
      @actions = hash.fetch(:actions).map { |action| action }
      @details = hash.fetch(:details).map { |detail| detail }
    end

    def optional?
      @optional
    end

    def completed?

    end

    def in_progress?

    end

  end
end
