class AddExternalStakeholderKickOff < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_introductory_emails, :boolean
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_local_authority_proforma, :boolean
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_confirm_target_conversion_date, :boolean
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_setup_meeting, :boolean
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_meeting, :boolean
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_conversion_checklist, :boolean
  end
end
