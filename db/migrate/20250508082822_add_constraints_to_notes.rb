class AddConstraintsToNotes < ActiveRecord::Migration[7.1]
  def change
    remove_index :notes, :user_id
    change_column_null :notes, :user_id, false
    add_index :notes, :user_id

    remove_index :notes, :project_id
    change_column_null :notes, :project_id, false
    add_index :notes, :project_id

    change_column_null :notes, :body, false
  end
end
