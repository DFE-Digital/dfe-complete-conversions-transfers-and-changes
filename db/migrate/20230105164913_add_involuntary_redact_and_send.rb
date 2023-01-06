class AddInvoluntaryRedactAndSend < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :redact_and_send_redact, :boolean
    add_column :conversion_involuntary_task_lists, :redact_and_send_save, :boolean
    add_column :conversion_involuntary_task_lists, :redact_and_send_send, :boolean
    add_column :conversion_involuntary_task_lists, :redact_and_send_send_solicitors, :boolean
  end
end
