class Conversion::Task::ConfirmChairOfGovernorsContactTaskForm < BaseTaskForm
  attribute :chair_of_governors_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    @key_contacts = KeyContacts.find_or_create_by(project: @project)

    super(@tasks_data, @user)
    self.chair_of_governors_contact_id = @key_contacts.chair_of_governors_id
  end

  def save
    @key_contacts.update!(chair_of_governors_id: chair_of_governors_contact_id)
  end

  private def completed?
    @key_contacts.chair_of_governors.present?
  end
end
