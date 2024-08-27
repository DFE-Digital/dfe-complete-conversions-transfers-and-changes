class UpdateTransferCommercialTransferAgreementTask < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :commercial_transfer_agreement_questions_received, :boolean, default: false
    add_column :transfer_tasks_data, :commercial_transfer_agreement_questions_checked, :boolean, default: false
  end
end
