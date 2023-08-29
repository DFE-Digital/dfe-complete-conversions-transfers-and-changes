class AddTransferChurchSupplementalAgreementTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :church_supplemental_agreement_received, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_cleared, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_signed_incoming_trust, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_signed_diocese, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_saved_after_signing_by_trust_diocese, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_saved_after_signing_by_secretary_state, :boolean
    add_column :transfer_tasks_data, :church_supplemental_agreement_not_applicable, :boolean
  end
end
