class AddTransferClosureOrTransferDeclarationTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :closure_or_transfer_declaration_not_applicable, :boolean
    add_column :transfer_tasks_data, :closure_or_transfer_declaration_received, :boolean
    add_column :transfer_tasks_data, :closure_or_transfer_declaration_cleared, :boolean
    add_column :transfer_tasks_data, :closure_or_transfer_declaration_saved, :boolean
    add_column :transfer_tasks_data, :closure_or_transfer_declaration_sent, :boolean
  end
end
