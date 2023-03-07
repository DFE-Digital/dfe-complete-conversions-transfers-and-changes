class ChangeAllConditionsMetTaskName < ActiveRecord::Migration[7.0]
  def change
    rename_column :conversion_involuntary_task_lists, :conditions_met_emailed, :conditions_met_confirm_all_conditions_met
    rename_column :conversion_voluntary_task_lists, :conditions_met_emailed, :conditions_met_confirm_all_conditions_met
  end
end
