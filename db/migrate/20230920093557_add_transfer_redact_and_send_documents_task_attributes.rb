class AddTransferRedactAndSendDocumentsTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :redact_and_send_documents_send_to_esfa, :boolean
    add_column :transfer_tasks_data, :redact_and_send_documents_redact, :boolean
    add_column :transfer_tasks_data, :redact_and_send_documents_saved, :boolean
    add_column :transfer_tasks_data, :redact_and_send_documents_send_to_funding_team, :boolean
    add_column :transfer_tasks_data, :redact_and_send_documents_send_to_solicitors, :boolean
  end
end
