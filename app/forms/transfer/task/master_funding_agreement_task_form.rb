class Transfer::Task::MasterFundingAgreementTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved, :boolean
  attribute :signed_secretary_state, :boolean
end
