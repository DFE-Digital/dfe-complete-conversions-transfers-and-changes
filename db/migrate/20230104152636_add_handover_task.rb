class AddHandoverTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :handover_notes, :boolean
    add_column :conversion_involuntary_task_lists, :handover_meeting, :boolean
  end
end
