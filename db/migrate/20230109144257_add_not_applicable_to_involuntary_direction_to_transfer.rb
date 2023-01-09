class AddNotApplicableToInvoluntaryDirectionToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :direction_to_transfer_not_applicable, :boolean
  end
end
