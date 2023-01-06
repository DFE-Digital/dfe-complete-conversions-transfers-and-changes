class AddInvoluntaryReceiveGrantPaymentCertificate < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :receive_grant_payment_certificate_check_and_save, :boolean
    add_column :conversion_involuntary_task_lists, :receive_grant_payment_certificate_update_kim, :boolean
    add_column :conversion_involuntary_task_lists, :receive_grant_payment_certificate_update_sheet, :boolean
  end
end
