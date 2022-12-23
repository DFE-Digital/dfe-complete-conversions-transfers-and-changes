class AddProcessConversionGrantTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :conversion_grant_check_vendor_account, :boolean
    add_column :conversion_voluntary_task_lists, :conversion_grant_eligibility, :boolean
    add_column :conversion_voluntary_task_lists, :conversion_grant_payment_form, :boolean
    add_column :conversion_voluntary_task_lists, :conversion_grant_send_information, :boolean
    add_column :conversion_voluntary_task_lists, :conversion_grant_share_payment_date, :boolean
    add_column :conversion_voluntary_task_lists, :conversion_grant_check_payment, :boolean
  end
end
