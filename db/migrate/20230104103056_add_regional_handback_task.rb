class AddRegionalHandbackTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :regional_handback_complete, :boolean
    add_column :conversion_voluntary_task_lists, :regional_handback_save, :boolean
    add_column :conversion_voluntary_task_lists, :regional_handback_send, :boolean
  end
end
