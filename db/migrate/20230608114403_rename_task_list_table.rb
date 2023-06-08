class RenameTaskListTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :conversion_voluntary_task_lists, :conversion_tasks_data
  end
end
