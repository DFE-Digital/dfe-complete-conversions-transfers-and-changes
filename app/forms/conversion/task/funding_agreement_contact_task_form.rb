class Conversion::Task::FundingAgreementContactTaskForm < ::BaseTaskForm
  attribute :contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user

    super(@tasks_data, @user)
  end

  def save
    @tasks_data.update(funding_agreement_contact_contact_id: contact_id)
  end
end
