class AddTypeToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :project_type, :integer, null: false, default: 0
  end
end
