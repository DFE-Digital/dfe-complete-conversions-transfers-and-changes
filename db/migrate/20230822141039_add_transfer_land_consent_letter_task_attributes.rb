class AddTransferLandConsentLetterTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :land_consent_letter_drafted, :boolean
    add_column :transfer_tasks_data, :land_consent_letter_signed, :boolean
    add_column :transfer_tasks_data, :land_consent_letter_sent, :boolean
    add_column :transfer_tasks_data, :land_consent_letter_saved, :boolean
    add_column :transfer_tasks_data, :land_consent_letter_not_applicable, :boolean
  end
end
