class RemoveTaskListIdAndTaskListTypeFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :task_list_type, :string
    remove_column :projects, :task_list_id, :uuid
  end
end
