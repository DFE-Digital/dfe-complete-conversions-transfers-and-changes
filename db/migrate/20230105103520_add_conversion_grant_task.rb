class AddConversionGrantTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :conversion_grant_eligibility, :boolean
    add_column :conversion_involuntary_task_lists, :conversion_grant_payment_amount, :boolean
    add_column :conversion_involuntary_task_lists, :conversion_grant_payment_form, :boolean
    add_column :conversion_involuntary_task_lists, :conversion_grant_send_information, :boolean
    add_column :conversion_involuntary_task_lists, :conversion_grant_inform_trust, :boolean
  end
end
