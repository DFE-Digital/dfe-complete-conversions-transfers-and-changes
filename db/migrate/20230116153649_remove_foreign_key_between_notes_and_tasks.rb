class RemoveForeignKeyBetweenNotesAndTasks < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :notes, :tasks
    remove_column :notes, :task_id, :uuid
  end
end
