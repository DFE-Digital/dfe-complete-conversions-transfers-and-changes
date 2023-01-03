class AddLandRegistryTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :land_registry_received, :boolean
    add_column :conversion_voluntary_task_lists, :land_registry_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :land_registry_saved, :boolean
  end
end
