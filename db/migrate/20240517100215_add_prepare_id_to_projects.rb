class AddPrepareIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :prepare_id, :integer
  end
end
