class Conversion::Task::TrustModificationOrderTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :sent_legal, :boolean
  attribute :cleared, :boolean
  attribute :saved, :boolean
end
