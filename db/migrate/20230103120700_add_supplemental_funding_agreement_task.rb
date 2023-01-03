class AddSupplementalFundingAgreementTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_received, :boolean
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_signed, :boolean
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_saved, :boolean
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_sent, :boolean
    add_column :conversion_voluntary_task_lists, :supplemental_funding_agreement_signed_secretary_state, :boolean
  end
end
