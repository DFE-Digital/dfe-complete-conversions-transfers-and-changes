class Conversion::Task::RiskProtectionArrangementTaskForm < BaseTaskForm
  attribute :option

  validates :option, inclusion: {in: %w[standard church_or_trust commercial]}
end
