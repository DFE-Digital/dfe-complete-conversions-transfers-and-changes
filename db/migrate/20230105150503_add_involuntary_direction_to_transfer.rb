class AddInvoluntaryDirectionToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :direction_to_transfer_received, :boolean
    add_column :conversion_involuntary_task_lists, :direction_to_transfer_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :direction_to_transfer_signed, :boolean
    add_column :conversion_involuntary_task_lists, :direction_to_transfer_saved, :boolean
  end
end
