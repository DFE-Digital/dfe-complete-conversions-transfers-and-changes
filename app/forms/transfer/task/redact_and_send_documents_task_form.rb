class Transfer::Task::RedactAndSendDocumentsTaskForm < BaseTaskForm
  attribute :send_to_esfa
  attribute :redact
  attribute :saved
  attribute :send_to_funding_team
  attribute :send_to_solicitors
end
