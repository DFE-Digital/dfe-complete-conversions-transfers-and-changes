class Transfer::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  alias_attribute :transfer_date, :significant_date
  alias_attribute :transfer_date_provisional, :significant_date_provisional

  validates :outgoing_trust_ukprn, presence: true
  validates :outgoing_trust_ukprn, ukprn: true

  MANDATORY_CONDITIONS = [
    :confirmed_date_and_in_the_past?,
    :authority_to_proceed?,
    :declaration_of_expenditure_certificate_task_completed?,
    :confirm_date_academy_transferred_task_completed?
  ]

  alias_attribute :authority_to_proceed, :all_conditions_met

  def declaration_of_expenditure_certificate_task_completed?
    user = assigned_to
    tasks = Transfer::Task::DeclarationOfExpenditureCertificateTaskForm.new(tasks_data, user)
    return true if tasks.status.eql?(:completed) || tasks.status.eql?(:not_applicable)
    false
  end

  def confirm_date_academy_transferred_task_completed?
    user = assigned_to
    tasks = Transfer::Task::ConfirmDateAcademyTransferredTaskForm.new(tasks_data, user)
    return true if tasks.status.eql?(:completed)
    false
  end

  def outgoing_trust
    @outgoing_trust ||= fetch_trust(outgoing_trust_ukprn)
  end

  def completable?
    MANDATORY_CONDITIONS.all? { |task| send(task) }
  end
end
