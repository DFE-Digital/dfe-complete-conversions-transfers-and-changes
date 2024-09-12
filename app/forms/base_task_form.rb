class BaseTaskForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Callbacks

  define_model_callbacks :save

  def self.identifier
    name.split("::").last.underscore.delete_suffix("_task_form")
  end

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    super(attributes_from_tasks_data)
  end

  def save
    run_callbacks :save do
      @tasks_data.assign_attributes prefixed_attributes
      @tasks_data.save!
    end
  end

  def identifier
    self.class.identifier.to_sym
  end

  def status
    return :not_applicable if not_applicable?
    return :completed if completed?
    return :in_progress if in_progress?

    :not_started
  end

  def locales_path
    self.class.name.underscore.delete_suffix("_task_form").tr("/", ".")
  end

  private def attributes_from_tasks_data
    @tasks_data.attributes
      .select { |key| key.start_with?(attribute_prefix.to_s) }
      .transform_keys { |key| key.delete_prefix(attribute_prefix.to_s + "_") }
  end

  private def prefixed_attributes
    attributes.transform_keys { |key| "#{attribute_prefix}_#{key}" }
  end

  private def attribute_prefix
    identifier
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
