class RenameProjectToConversionproject < ActiveRecord::Migration[7.0]
  def change
    rename_table :projects, :conversion_projects
    rename_column :notes, :project_id, :conversion_project_id
    rename_column :sections, :project_id, :conversion_project_id
    rename_column :contacts, :project_id, :conversion_project_id
  end
end
