class Conversion::Task::TenancyAtWillTaskForm < BaseOptionalTaskForm
  attribute :email_signed, :boolean
  attribute :receive_signed, :boolean
  attribute :save_signed, :boolean
end
