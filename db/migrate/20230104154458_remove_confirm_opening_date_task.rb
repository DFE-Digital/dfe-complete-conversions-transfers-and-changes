class RemoveConfirmOpeningDateTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :confirm_opening_date_emailed
  end
end
