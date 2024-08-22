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

  def selectable_contacts
    project_contacts = @project.contacts.school_or_academy.to_a
    project_contacts << Contact::Establishment.find_by(establishment_urn: @project.urn)
    project_contacts.compact
  end

  private def completed?
    @key_contacts.headteacher.present?
  end
end
