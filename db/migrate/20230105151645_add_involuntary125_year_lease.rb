class AddInvoluntary125YearLease < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :one_hundred_and_twenty_five_year_lease_not_applicable, :boolean
    add_column :conversion_involuntary_task_lists, :one_hundred_and_twenty_five_year_lease_email, :boolean
    add_column :conversion_involuntary_task_lists, :one_hundred_and_twenty_five_year_lease_receive, :boolean
    add_column :conversion_involuntary_task_lists, :one_hundred_and_twenty_five_year_lease_save, :boolean
  end
end
