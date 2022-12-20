class TaskList::Base < ActiveRecord::Base
  include TaskList

  self.abstract_class = true

  def sections
    task_list_layout.map do |section|
      tasks = section[:tasks].map { |task| task.new(attributes_for_task(task)) }

      TaskList::Section.new(identifier: section[:identifier], tasks: tasks, locales_path: locales_path)
    end
  end

  def locales_path
    self.class.name.underscore.tr("/", ".")
  end

  def tasks
    sections.map(&:tasks).flatten
  end

  def task(identifier)
    tasks.find { |task| task.class.identifier == identifier }
  end

  def save_task(task)
    assign_attributes(attributes_for_task_list(task))
    save!
  end

  def task_list_layout
    raise NoMethodError, "Task lists must define a `#task_list_layout`."
  end

  private def attributes_for_task(task)
    attributes
      .select { |key| key.start_with?(task.identifier) }
      .transform_keys { |key| key.sub("#{task.identifier}_", "") }
  end

  private def attributes_for_task_list(task)
    task.attributes.transform_keys { |key| "#{task.class.identifier}_#{key}" }
  end
end
