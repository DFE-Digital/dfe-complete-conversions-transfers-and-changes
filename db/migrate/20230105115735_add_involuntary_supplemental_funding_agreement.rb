class AddInvoluntarySupplementalFundingAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_received, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_signed, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_saved, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_sent, :boolean
    add_column :conversion_involuntary_task_lists, :supplemental_funding_agreeement_signed_secretary_state, :boolean
  end
end
