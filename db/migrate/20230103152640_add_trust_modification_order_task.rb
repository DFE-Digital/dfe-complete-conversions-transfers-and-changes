class AddTrustModificationOrderTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :trust_modification_order_received, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_sent_legal, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_saved, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_sent, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_signed_secretary_state, :boolean
  end
end
