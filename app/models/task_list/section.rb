class TaskList::Section
  attr_accessor :identifier, :tasks

  def initialize(identifier:, tasks:)
    @identifier = identifier
    @tasks = tasks
  end
end
