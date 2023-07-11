class Conversion::Task::CompleteNotificationOfChangeTaskForm < BaseOptionalTaskForm
  attribute :not_applicable, :boolean
  attribute :tell_local_authority, :boolean
  attribute :check_document, :boolean
  attribute :send_document, :boolean
end
