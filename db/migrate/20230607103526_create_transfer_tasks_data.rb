class CreateTransferTasksData < ActiveRecord::Migration[7.0]
  def change
    create_table :transfer_tasks_data, id: :uuid do |t|
      t.timestamps
    end
  end
end
