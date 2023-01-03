class AddDirectionToTransferTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_received, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_signed, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_saved, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_sent, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_signed_secretary_state, :boolean
  end
end
