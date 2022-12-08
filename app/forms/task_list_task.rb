class TaskListTask
  # Named like this so it doesn't conflict with Task
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def key
      name.split("::").last.underscore
    end

    def readable_name
      key.humanize
    end
  end

  def in_progress?
    attributes.values.any?(&:present?)
  end

  def completed?
    attributes.values.all?(&:present?)
  end

  def not_applicable?
    false
  end
end
