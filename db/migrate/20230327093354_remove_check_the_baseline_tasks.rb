class RemoveCheckTheBaselineTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :check_baseline_confirm, :boolean
    remove_column :conversion_involuntary_task_lists, :check_baseline_confirm, :boolean
  end
end
