class AddInvoluntaryMasterFundingAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :master_funding_agreement_received, :boolean
    add_column :conversion_involuntary_task_lists, :master_funding_agreement_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :master_funding_agreement_signed, :boolean
    add_column :conversion_involuntary_task_lists, :master_funding_agreement_saved, :boolean

    add_column :conversion_involuntary_task_lists, :master_funding_agreement_sent, :boolean
    add_column :conversion_involuntary_task_lists, :master_funding_agreement_signed_secretary_state, :boolean
  end
end
