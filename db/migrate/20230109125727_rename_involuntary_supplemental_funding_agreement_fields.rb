class RenameInvoluntarySupplementalFundingAgreementFields < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_received, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_signed, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_saved, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_sent, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreement_signed_secretary_state, :boolean

    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_received, :boolean
    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_cleared, :boolean
    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_signed, :boolean
    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_saved, :boolean
    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_sent, :boolean
    remove_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_signed_secretary_state, :boolean
  end
end
