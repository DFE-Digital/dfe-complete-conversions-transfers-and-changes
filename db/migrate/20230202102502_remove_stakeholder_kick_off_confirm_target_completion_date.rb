class RemoveStakeholderKickOffConfirmTargetCompletionDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :stakeholder_kick_off_confirm_target_conversion_date
  end
end
