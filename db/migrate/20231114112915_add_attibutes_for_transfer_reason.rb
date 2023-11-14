class AddAttibutesForTransferReason < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :inadequate_ofsted, :boolean, default: false
    add_column :transfer_tasks_data, :financial_safeguarding_governance_issues, :boolean, default: false
    add_column :transfer_tasks_data, :trust_to_close, :boolean, default: false
  end
end
