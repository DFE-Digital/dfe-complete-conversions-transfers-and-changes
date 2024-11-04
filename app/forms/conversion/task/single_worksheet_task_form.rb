class Conversion::Task::SingleWorksheetTaskForm < BaseTaskForm
  attribute :complete, :boolean
  attribute :approve, :boolean
  attribute :send, :boolean
end
