class Transfer::Task::CommercialTransferAgreementTaskForm < BaseTaskForm
  attribute :confirm_agreed, :boolean
  attribute :confirm_signed, :boolean
  attribute :save_confirmation_emails, :boolean
end
