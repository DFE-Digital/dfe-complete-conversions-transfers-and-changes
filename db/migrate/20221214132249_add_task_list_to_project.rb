class AddTaskListToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :task_list_id, :uuid
    add_column :projects, :task_list_type, :string
  end
end
