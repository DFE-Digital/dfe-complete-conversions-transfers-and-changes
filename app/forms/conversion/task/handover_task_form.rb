class Conversion::Task::HandoverTaskForm < BaseOptionalTaskForm
  attribute :review, :boolean
  attribute :notes, :boolean
  attribute :meeting, :boolean
end
