class AddTaskKeyToNote < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :task_key, :string
  end
end
