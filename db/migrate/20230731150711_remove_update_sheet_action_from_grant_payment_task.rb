class RemoveUpdateSheetActionFromGrantPaymentTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_tasks_data, :receive_grant_payment_certificate_update_sheet, :boolean
  end
end
