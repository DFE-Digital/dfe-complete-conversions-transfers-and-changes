class AddDeedTerminationChurchAgreementTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :deed_termination_church_agreement_received, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_cleared, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_signed_outgoing_trust, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_signed_diocese, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_saved, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_saved_after_signing_by_secretary_state, :boolean
    add_column :transfer_tasks_data, :deed_termination_church_agreement_not_applicable, :boolean
  end
end
