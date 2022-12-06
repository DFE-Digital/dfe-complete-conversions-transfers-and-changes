class TaskListTask
  # Named like this so it doesn't conflict with Task
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def key
      name.split("::").last.underscore
    end

    def readable_name
      name.split("::").last.underscore.humanize
    end
  end
end
