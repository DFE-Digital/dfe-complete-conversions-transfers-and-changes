class RemoveDefaultFromProjectType < ActiveRecord::Migration[7.0]
  def change
    change_column_default :projects, :project_type, nil
  end
end
