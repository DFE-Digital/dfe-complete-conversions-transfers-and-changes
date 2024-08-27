class Transfer::Task::CommercialTransferAgreementTaskForm < BaseTaskForm
  attribute :confirm_agreed, :boolean
  attribute :confirm_signed, :boolean
  attribute :questions_received, :boolean
  attribute :questions_checked, :boolean
  attribute :save_confirmation_emails, :boolean
end
