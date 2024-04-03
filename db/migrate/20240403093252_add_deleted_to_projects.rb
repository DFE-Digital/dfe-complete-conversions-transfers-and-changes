class AddDeletedToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :deleted, :boolean, null: false, default: false
  end
end
