class Projects::Conversions::Tasks::AcademyNameTaskForm < Projects::Conversions::Tasks::BaseTask
  attribute :academy_name

  ATTRIBUTE_PREFIX = :academy_name

  def initialize(task_list)
    @task_list = task_list
    @project = task_list.project
    attributes = task_attributes
    attributes["academy_name"] = @project.academy_name
    super(attributes)
  end

  def save
    @project.academy_name = academy_name
    @project.save!
  end

  def attribute_prefix
    ATTRIBUTE_PREFIX
  end
end
