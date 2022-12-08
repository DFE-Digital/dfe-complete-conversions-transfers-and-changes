class TaskList::Section
  attr_accessor :title, :tasks

  def initialize(title:, tasks:)
    @title = title
    @tasks = tasks
  end
end
