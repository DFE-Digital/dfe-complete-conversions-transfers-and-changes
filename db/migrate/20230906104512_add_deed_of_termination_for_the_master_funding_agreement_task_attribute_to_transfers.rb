class AddDeedOfTerminationForTheMasterFundingAgreementTaskAttributeToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_received, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_cleared, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_signed, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_saved_academy_and_outgoing_trust_sharepoint, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_contact_financial_reporting_team, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_saved_in_academy_sharepoint_folder, :boolean
    add_column :transfer_tasks_data, :deed_of_termination_for_the_master_funding_agreement_not_applicable, :boolean
  end
end
