class Conversion::Task::ConfirmHeadteacherContactTaskForm < BaseTaskForm
  attribute :headteacher_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    @key_contacts = KeyContacts.find_or_create_by(project: @project)

    super(@tasks_data, @user)
    self.headteacher_contact_id = @key_contacts.headteacher_id
  end

  def save
    @key_contacts.update!(headteacher_id: headteacher_contact_id)
  end

  private def completed?
    @key_contacts.headteacher.present?
  end
end
