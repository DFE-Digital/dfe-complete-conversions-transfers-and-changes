class AddConversionCompleteNotificationOfChangeTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :complete_notification_of_change_not_applicable, :boolean
    add_column :conversion_tasks_data, :complete_notification_of_change_tell_local_authority, :boolean
    add_column :conversion_tasks_data, :complete_notification_of_change_check_document, :boolean
    add_column :conversion_tasks_data, :complete_notification_of_change_send_document, :boolean
  end
end
