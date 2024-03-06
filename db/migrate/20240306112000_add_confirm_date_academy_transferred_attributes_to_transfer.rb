class AddConfirmDateAcademyTransferredAttributesToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :confirm_date_academy_transferred_date_transferred, :date
  end
end
