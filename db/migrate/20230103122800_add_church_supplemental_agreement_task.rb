class AddChurchSupplementalAgreementTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_received, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_signed, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_signed_diocese, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_saved, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_sent, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_signed_secretary_state, :boolean
  end
end
