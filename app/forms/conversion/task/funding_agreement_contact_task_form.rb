class Conversion::Task::FundingAgreementContactTaskForm < ::BaseTaskForm
  attribute :funding_agreement_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project

    super(@tasks_data, @user)
    self.funding_agreement_contact_id = @project.funding_agreement_contact_id
  end

  def save
    @project.update!(funding_agreement_contact_id: funding_agreement_contact_id)
  end

  private def completed?
    @project.funding_agreement_contact_id.present?
  end
end
