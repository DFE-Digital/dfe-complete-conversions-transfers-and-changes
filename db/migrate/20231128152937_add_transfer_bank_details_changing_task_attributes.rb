class AddTransferBankDetailsChangingTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :bank_details_changing_yes_no, :boolean, default: false
  end
end
