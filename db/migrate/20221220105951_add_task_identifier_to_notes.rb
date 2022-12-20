class AddTaskIdentifierToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :task_identifier, :string
  end
end
