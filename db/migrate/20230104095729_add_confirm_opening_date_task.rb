class AddConfirmOpeningDateTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :confirm_opening_date_emailed, :boolean
  end
end
