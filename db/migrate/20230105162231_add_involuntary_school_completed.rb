class AddInvoluntarySchoolCompleted < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :school_completed_emailed, :boolean
    add_column :conversion_involuntary_task_lists, :school_completed_saved, :boolean
  end
end
