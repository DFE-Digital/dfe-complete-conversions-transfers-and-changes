class AddProjectCreatorId < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :creator_id, :uuid, null: true
    add_index :projects, :creator_id
    add_foreign_key :projects, :users, column: :creator_id
  end
end
