class AddStakeholderKickoffAttributesToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :stakeholder_kick_off_introductory_emails, :boolean
    add_column :transfer_tasks_data, :stakeholder_kick_off_setup_meeting, :boolean
    add_column :transfer_tasks_data, :stakeholder_kick_off_meeting, :boolean
  end
end
