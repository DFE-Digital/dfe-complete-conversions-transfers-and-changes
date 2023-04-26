class DoNotUseSaveAsAnAttribute < ActiveRecord::Migration[7.0]
  def change
    rename_column :conversion_voluntary_task_lists, :redact_and_send_save, :redact_and_send_save_redaction
    rename_column :conversion_voluntary_task_lists, :redact_and_send_send, :redact_and_send_send_redaction

    rename_column :conversion_voluntary_task_lists, :one_hundred_and_twenty_five_year_lease_save, :one_hundred_and_twenty_five_year_lease_save_lease
  end
end
