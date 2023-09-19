class Transfer::Task::ClosureOrTransferDeclarationTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :saved, :boolean
  attribute :sent, :boolean
end
