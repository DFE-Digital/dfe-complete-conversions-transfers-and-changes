class AddInvoluntaryTenancyAtWill < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :tenancy_at_will_email_signed, :boolean
    add_column :conversion_involuntary_task_lists, :tenancy_at_will_receive_signed, :boolean
    add_column :conversion_involuntary_task_lists, :tenancy_at_will_save_signed, :boolean
    add_column :conversion_involuntary_task_lists, :tenancy_at_will_not_applicable, :boolean
  end
end
