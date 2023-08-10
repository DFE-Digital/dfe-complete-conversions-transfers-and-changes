class AddCommercialTransferAgreementTaskAttributeToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :commercial_transfer_agreement_confirm_agreed, :boolean
    add_column :transfer_tasks_data, :commercial_transfer_agreement_confirm_signed, :boolean
    add_column :transfer_tasks_data, :commercial_transfer_agreement_save_confirmation_emails, :boolean
  end
end
