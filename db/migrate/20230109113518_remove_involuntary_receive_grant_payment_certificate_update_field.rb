class RemoveInvoluntaryReceiveGrantPaymentCertificateUpdateField < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_involuntary_task_lists, :receive_grant_payment_certificate_update_sheet, :boolean
  end
end
