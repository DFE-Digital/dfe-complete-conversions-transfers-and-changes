class TaskList::Task
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def identifier
      name.split("::").last.underscore
    end
  end

  def status
    return :not_applicable if not_applicable?
    return :completed if completed?
    return :in_progress if in_progress?

    :not_started
  end

  def title
    I18n.t("task_list.tasks.#{self.class.identifier}.title")
  end

  private def in_progress?
    attributes.values.any?(&:present?)
  end

  private def completed?
    attributes.values.all?(&:present?)
  end

  private def not_applicable?
    false
  end
end
