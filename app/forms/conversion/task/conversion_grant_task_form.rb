class Conversion::Task::ConversionGrantTaskForm < BaseOptionalTaskForm
  attribute :check_vendor_account, :boolean
  attribute :payment_form, :boolean
  attribute :send_information, :boolean
  attribute :share_payment_date, :boolean
end
