class RemoveAttributesFromDirectionToTransferTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :direction_to_transfer_sent
    remove_column :conversion_voluntary_task_lists, :direction_to_transfer_signed_secretary_state
  end
end
