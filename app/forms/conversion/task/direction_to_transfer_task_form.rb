class Conversion::Task::DirectionToTransferTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved, :boolean
end
