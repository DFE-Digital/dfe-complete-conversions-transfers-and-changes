class DropConversionInvoluntaryTaskListTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :conversion_involuntary_task_lists
  end
end
