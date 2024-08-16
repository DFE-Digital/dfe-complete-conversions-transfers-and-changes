class Conversion::Task::ConfirmIncomingTrustCeoContactTaskForm < BaseTaskForm
  attribute :incoming_trust_ceo_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    @key_contacts = KeyContacts.find_or_create_by(project: @project)

    super(@tasks_data, @user)
    self.incoming_trust_ceo_contact_id = @key_contacts.incoming_trust_ceo_id
  end

  def save
    @key_contacts.update!(incoming_trust_ceo_id: incoming_trust_ceo_contact_id)
  end

  private def completed?
    @key_contacts.incoming_trust_ceo.present?
  end
end
