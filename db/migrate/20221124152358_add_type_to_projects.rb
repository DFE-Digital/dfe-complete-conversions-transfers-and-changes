class AddTypeToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :type, :string
  end
end
