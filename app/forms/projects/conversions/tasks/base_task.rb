class Projects::Conversions::Tasks::BaseTask
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def identifier
      name.split("::").last.underscore.delete_suffix("_task_form")
    end
  end

  def status
    return :not_applicable if not_applicable?
    return :completed if completed?
    return :in_progress if in_progress?

    :not_started
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

  def locales_path
    self.class.name.underscore.delete_suffix("_task_form").tr("/", ".")
  end

  def task_attributes
    @task_list.attributes
      .select { |key| key.start_with?(attribute_prefix.to_s) }
      .transform_keys { |key| key.delete_prefix(attribute_prefix.to_s + "_") }
  end

  def prefixed_attributes
    attributes.transform_keys { |key| "#{attribute_prefix}_#{key}" }
  end

  def attribute_prefix
    raise NotImplementedError
  end
end
