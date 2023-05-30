class AddFundingLettersContactIdToTasksData < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :funding_agreement_contact_contact_id, :uuid
  end
end
