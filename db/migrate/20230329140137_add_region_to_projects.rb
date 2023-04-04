class AddRegionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :region, :string
  end
end
