class Conversion::Voluntary::Tasks::RedactAndSend < TaskList::Task
  attribute :redact
  attribute :save_redaction
  attribute :send_redaction
  attribute :send_solicitors
end
