class RemoveAttributesFromTrustModificationTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :trust_modification_order_sent
    remove_column :conversion_voluntary_task_lists, :trust_modification_order_signed_secretary_state
  end
end
