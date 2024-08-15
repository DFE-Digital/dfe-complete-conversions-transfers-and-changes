class Transfer::Task::ConfirmOutgoingTrustCeoContactTaskForm < BaseTaskForm
  attribute :outgoing_trust_ceo_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    @key_contacts = KeyContacts.find_or_create_by(project: @project)

    super(@tasks_data, @user)
    self.outgoing_trust_ceo_contact_id = @key_contacts.outgoing_trust_ceo_id
  end

  def save
    @key_contacts.update!(outgoing_trust_ceo_id: outgoing_trust_ceo_contact_id)
  end

  private def completed?
    @key_contacts.outgoing_trust_ceo.present?
  end
end
