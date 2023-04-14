class Projects::Conversions::Tasks::HandoverTaskForm < Projects::Conversions::Tasks::OptionalTask
  attribute :review
  attribute :notes
  attribute :meeting

  ATTRIBUTE_PREFIX = :handover

  def initialize(task_list)
    @task_list = task_list
    super(task_attributes)
  end

  def save
    @task_list.assign_attributes prefixed_attributes.except("handover_task_list")
    @task_list.save!
  end

  def locales_path
    self.class.name.underscore.delete_suffix("_task_form").tr("/", ".")
  end

  private def task_attributes
    @task_list.attributes
      .select { |key| key.start_with?(ATTRIBUTE_PREFIX.to_s) }
      .transform_keys { |key| key.delete_prefix("#{ATTRIBUTE_PREFIX}_") }
  end

  private def prefixed_attributes
    attributes.transform_keys { |key| "#{ATTRIBUTE_PREFIX}_#{key}" }
  end
end
