class Conversion::Task::RedactAndSendTaskForm < ::BaseTaskForm
  attribute :redact, :boolean
  attribute :send_redaction, :boolean
  attribute :save_redaction, :boolean
  attribute :send_solicitors, :boolean
end
