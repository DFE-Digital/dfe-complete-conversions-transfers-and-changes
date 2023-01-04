class AddCommercialTransferAgreementTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :commercial_transfer_agreement_email_signed, :boolean
    add_column :conversion_voluntary_task_lists, :commercial_transfer_agreement_receive_signed, :boolean
    add_column :conversion_voluntary_task_lists, :commercial_transfer_agreement_save_signed, :boolean
  end
end
