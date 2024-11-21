class ChangeDefaultValueOfBankDetailsChangingTask < ActiveRecord::Migration[7.1]
  def change
    change_column :transfer_tasks_data, :bank_details_changing_yes_no, :boolean, default: nil
  end
end
