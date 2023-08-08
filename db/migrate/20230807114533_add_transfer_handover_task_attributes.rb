class AddTransferHandoverTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :handover_review, :boolean
    add_column :transfer_tasks_data, :handover_notes, :boolean
    add_column :transfer_tasks_data, :handover_meeting, :boolean
    add_column :transfer_tasks_data, :handover_not_applicable, :boolean
  end
end
