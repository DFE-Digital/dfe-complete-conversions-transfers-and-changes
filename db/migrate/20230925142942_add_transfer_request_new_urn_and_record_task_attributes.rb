class AddTransferRequestNewUrnAndRecordTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :request_new_urn_and_record_not_applicable, :boolean
    add_column :transfer_tasks_data, :request_new_urn_and_record_complete, :boolean
    add_column :transfer_tasks_data, :request_new_urn_and_record_receive, :boolean
    add_column :transfer_tasks_data, :request_new_urn_and_record_give, :boolean
  end
end
