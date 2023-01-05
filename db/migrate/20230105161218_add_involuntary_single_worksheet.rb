class AddInvoluntarySingleWorksheet < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :single_worksheet_complete, :boolean
    add_column :conversion_involuntary_task_lists, :single_worksheet_approve, :boolean
    add_column :conversion_involuntary_task_lists, :single_worksheet_send, :boolean
  end
end
