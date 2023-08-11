class AddTransferSupplementalFundingAgreementTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :supplemental_funding_agreement_received, :boolean
    add_column :transfer_tasks_data, :supplemental_funding_agreement_cleared, :boolean
    add_column :transfer_tasks_data, :supplemental_funding_agreement_saved, :boolean
  end
end
