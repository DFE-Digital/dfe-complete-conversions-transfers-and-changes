class RenameCaseworker < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :caseworker, :assign_to_project
  end
end
