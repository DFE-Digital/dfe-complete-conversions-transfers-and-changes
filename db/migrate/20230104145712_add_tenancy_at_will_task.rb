class AddTenancyAtWillTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :tenancy_at_will_email_signed, :boolean
    add_column :conversion_voluntary_task_lists, :tenancy_at_will_receive_signed, :boolean
    add_column :conversion_voluntary_task_lists, :tenancy_at_will_save_signed, :boolean
  end
end
