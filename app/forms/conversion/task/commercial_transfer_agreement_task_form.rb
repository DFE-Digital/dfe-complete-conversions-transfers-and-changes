class Conversion::Task::CommercialTransferAgreementTaskForm < BaseTaskForm
  attribute :agreed, :boolean
  attribute :signed, :boolean
  attribute :questions_received, :boolean
  attribute :questions_checked, :boolean
  attribute :saved, :boolean
end
