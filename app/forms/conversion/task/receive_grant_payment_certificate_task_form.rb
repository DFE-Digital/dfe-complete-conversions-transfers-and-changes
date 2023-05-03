class Conversion::Task::ReceiveGrantPaymentCertificateTaskForm < BaseTaskForm
  attribute :check_and_save, :boolean
  attribute :update_kim, :boolean
  attribute :update_sheet, :boolean
end
