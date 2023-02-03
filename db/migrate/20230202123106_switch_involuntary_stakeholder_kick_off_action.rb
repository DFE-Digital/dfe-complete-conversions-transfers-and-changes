class SwitchInvoluntaryStakeholderKickOffAction < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_involuntary_task_lists, :stakeholder_kick_off_confirm_target_conversion_date
    add_column :conversion_involuntary_task_lists, :stakeholder_kick_off_confirmed_conversion_date, :date
  end
end
