class TaskList::Section
  attr_accessor :identifier, :tasks

  def initialize(identifier:, tasks:, locales_path:)
    @locales_path = locales_path
    @identifier = identifier
    @tasks = tasks
  end

  def locales_path
    "#{@locales_path}.#{identifier}"
  end
end
