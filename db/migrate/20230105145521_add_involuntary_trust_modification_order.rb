class AddInvoluntaryTrustModificationOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :trust_modification_order_received, :boolean
    add_column :conversion_involuntary_task_lists, :trust_modification_order_sent_legal, :boolean
    add_column :conversion_involuntary_task_lists, :trust_modification_order_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :trust_modification_order_saved, :boolean
  end
end
