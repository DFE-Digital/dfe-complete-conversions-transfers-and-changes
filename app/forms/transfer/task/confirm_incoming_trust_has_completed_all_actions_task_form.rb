class Transfer::Task::ConfirmIncomingTrustHasCompletedAllActionsTaskForm < BaseTaskForm
  attribute :emailed, :boolean
  attribute :saved, :boolean
end
