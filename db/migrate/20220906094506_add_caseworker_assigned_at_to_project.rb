class AddCaseworkerAssignedAtToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :caseworker_assigned_at, :datetime
  end
end
