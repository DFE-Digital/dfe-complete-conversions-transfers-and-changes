class HandoverTaskIsOptional < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :handover_not_applicable, :boolean
  end
end
