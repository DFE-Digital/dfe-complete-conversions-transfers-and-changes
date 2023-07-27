class AddCheckSignificantDateToTransferTaskData < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :stakeholder_kick_off_check_significant_date, :boolean
  end
end
