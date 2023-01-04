class AddActionToRedactAndSendTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :redact_and_send_send_solicitors, :boolean
  end
end
