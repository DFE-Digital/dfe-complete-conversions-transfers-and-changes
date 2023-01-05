class AddSubleasesToInvoluntaryConversionTaskList < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :subleases_not_applicable, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_received, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_signed, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_saved, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_email_signed, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_receive_signed, :boolean
    add_column :conversion_involuntary_task_lists, :subleases_save_signed, :boolean
  end
end
