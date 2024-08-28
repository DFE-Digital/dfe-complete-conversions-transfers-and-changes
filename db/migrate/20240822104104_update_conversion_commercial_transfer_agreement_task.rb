class UpdateConversionCommercialTransferAgreementTask < ActiveRecord::Migration[7.0]
  def up
    # Add new columns
    add_column :conversion_tasks_data, :commercial_transfer_agreement_agreed, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_signed, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_questions_received, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_questions_checked, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_saved, :boolean, default: false

    # migrate data
    Conversion::TasksData.all.each do |t|
      if t.commercial_transfer_agreement_email_signed
        t.commercial_transfer_agreement_agreed = true
        t.commercial_transfer_agreement_signed = true
      end

      if t.commercial_transfer_agreement_receive_signed
        t.commercial_transfer_agreement_questions_received = true
      end

      if t.commercial_transfer_agreement_save_signed
        t.commercial_transfer_agreement_saved = true
      end

      t.save(validate: false)
    end

    # remove columns
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_email_signed, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_receive_signed, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_save_signed, :boolean
  end

  def down
    # restore old columns
    add_column :conversion_tasks_data, :commercial_transfer_agreement_email_signed, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_receive_signed, :boolean, default: false
    add_column :conversion_tasks_data, :commercial_transfer_agreement_save_signed, :boolean, default: false

    # migrate data
    Conversion::TasksData.all.each do |t|
      if t.commercial_transfer_agreement_agreed && t.commercial_transfer_agreement_signed
        t.commercial_transfer_agreement_email_signed = true
      end

      if t.commercial_transfer_agreement_questions_received
        t.commercial_transfer_agreement_receive_signed = true
      end

      if t.commercial_transfer_agreement_saved
        t.commercial_transfer_agreement_save_signed = true
      end

      t.save(validate: false)
    end

    # remove new columns
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_agreed, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_signed, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_questions_received, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_questions_checked, :boolean
    remove_column :conversion_tasks_data, :commercial_transfer_agreement_saved, :boolean
  end
end
