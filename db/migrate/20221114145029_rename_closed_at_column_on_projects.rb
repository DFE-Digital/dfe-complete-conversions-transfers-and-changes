class RenameClosedAtColumnOnProjects < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :closed_at, :completed_at
  end
end
