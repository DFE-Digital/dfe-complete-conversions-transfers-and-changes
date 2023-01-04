class RemoveRegionalHandbackTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :regional_handback_complete
    remove_column :conversion_voluntary_task_lists, :regional_handback_save
    remove_column :conversion_voluntary_task_lists, :regional_handback_send
  end
end
