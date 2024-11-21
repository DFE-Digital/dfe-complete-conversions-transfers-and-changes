class RemoveSingleWorksheetTaskColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :conversion_tasks_data, :single_worksheet_approve, :boolean
    remove_column :conversion_tasks_data, :single_worksheet_complete, :boolean
    remove_column :conversion_tasks_data, :single_worksheet_send, :boolean
  end
end
