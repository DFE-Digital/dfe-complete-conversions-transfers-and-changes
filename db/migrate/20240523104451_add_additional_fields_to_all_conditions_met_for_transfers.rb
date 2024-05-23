class AddAdditionalFieldsToAllConditionsMetForTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :conditions_met_check_any_information_changed, :boolean
    add_column :transfer_tasks_data, :conditions_met_baseline_sheet_approved, :boolean
  end
end
