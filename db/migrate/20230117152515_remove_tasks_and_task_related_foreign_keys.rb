class RemoveTasksAndTaskRelatedForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :tasks, :sections
    remove_foreign_key :sections, :projects
    remove_foreign_key :actions, :tasks
    drop_table :tasks
    drop_table :sections
    drop_table :actions
  end
end
