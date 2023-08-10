class AddMasterFundingAgreementAttributesToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :master_funding_agreement_received, :boolean
    add_column :transfer_tasks_data, :master_funding_agreement_cleared, :boolean
    add_column :transfer_tasks_data, :master_funding_agreement_signed, :boolean
    add_column :transfer_tasks_data, :master_funding_agreement_saved, :boolean
    add_column :transfer_tasks_data, :master_funding_agreement_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :master_funding_agreement_not_applicable, :boolean
  end
end
