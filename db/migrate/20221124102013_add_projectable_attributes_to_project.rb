class AddProjectableAttributesToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :projectable_type, :string
    add_column :projects, :projectable_id, :integer
  end
end
