class Projects::Conversions::Tasks::MainContactTaskForm < Projects::Conversions::Tasks::OptionalTask
  attribute :title
  attribute :name
  attribute :email
  attribute :phone

  ATTRIBUTE_PREFIX = :main_contact_task_form

  def initialize(task_list)
    @task_list = task_list
    @project = task_list.project
    @contact = @project.main_contact
    if @contact.present?
    attributes = {
      name: @contact.name,
      title: @contact.title,
      email: @contact.email,
      phone: @contact.phone
    }
    else
      attributes = task_attributes
    end
    super(attributes)
  end

  def save
    @project.main_contact = Contact.new(
      project_id: @project.id,
      name: name,
      title: title,
      email: email,
      phone: phone,
      organisation_name: @project.establishment.name
    )

    @project.save!
  end

  def attribute_prefix
    ATTRIBUTE_PREFIX
  end
end
