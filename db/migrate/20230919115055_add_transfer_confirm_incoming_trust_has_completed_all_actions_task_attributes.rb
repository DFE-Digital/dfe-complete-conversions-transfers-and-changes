class AddTransferConfirmIncomingTrustHasCompletedAllActionsTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :confirm_incoming_trust_has_completed_all_actions_emailed, :boolean
    add_column :transfer_tasks_data, :confirm_incoming_trust_has_completed_all_actions_saved, :boolean
  end
end
