class Conversion::Task::SubleasesTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved, :boolean
  attribute :email_signed, :boolean
  attribute :receive_signed, :boolean
  attribute :save_signed, :boolean
end
