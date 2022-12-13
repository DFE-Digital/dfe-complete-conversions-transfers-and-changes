class TaskList::Base < ActiveRecord::Base
  self.abstract_class = true

  def sections
    task_list_layout.map do |section|
      tasks = section[:tasks].map { |task| task.new(attributes_for_task(task)) }

      TaskList::Section.new(identifier: section[:identifier], tasks: tasks)
    end
  end

  def tasks
    sections.map(&:tasks).flatten
  end

  def task(key)
    tasks.find { |task| task.class.key == key }
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
      .select { |key| key.start_with?(task.key) }
      .transform_keys { |key| key.sub("#{task.key}_", "") }
  end

  private def attributes_for_task_list(task)
    task.attributes.transform_keys { |key| "#{task.class.key}_#{key}" }
  end
end
