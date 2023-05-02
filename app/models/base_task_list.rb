class BaseTaskList
  attr_reader :sections, :tasks

  def initialize(project, user)
    @project = project
    @user = user
    @tasks_data = project.task_list
    @sections = initialize_sections
    @tasks = all_tasks
  end

  def all_tasks
    @sections.map { |section| section.tasks }.flatten
  end

  private def initialize_sections
    self.class.layout.map do |section|
      tasks = initialize_tasks(section[:tasks])
      Section.new(section[:identifier], tasks, locales_path)
    end
  end

  def initialize_tasks(klasses)
    klasses.map do |task_klass|
      task_klass.new(@tasks_data, @user)
    end
  end

  private def locales_path
    self.class.name.underscore.tr("/", ".")
  end

  class << self
    def identifiers
      task_klasses.map { |klass| klass_to_identifier(klass) }
    end

    def layout
      raise NotImplementedError, "You must implement the layout class method on your task list"
    end

    private def klass_to_identifier(klass)
      klass.name.split("::").last.underscore.delete_suffix("_task_form").to_sym
    end

    private def task_klasses
      layout.map { |section| section[:tasks] }.flatten
    end
  end

  class Section
    attr_reader :identifier, :tasks, :locales_path

    def initialize(identifier, tasks, locales_path_prefix)
      @identifier = identifier
      @tasks = tasks
      @locales_path = "#{locales_path_prefix}.#{identifier}"
    end
  end
end
