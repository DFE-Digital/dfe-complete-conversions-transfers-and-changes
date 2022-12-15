class TaskList::Section
  attr_accessor :identifier, :tasks

  def initialize(identifier:, tasks:)
    @identifier = identifier
    @tasks = tasks
  end

  def title
    I18n.t("task_list.sections.#{identifier}.title")
  end
end
