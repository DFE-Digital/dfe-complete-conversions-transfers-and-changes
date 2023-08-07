class AddAllConditionsMetTaskToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :conditions_met_confirm_all_conditions_met, :boolean
  end
end
