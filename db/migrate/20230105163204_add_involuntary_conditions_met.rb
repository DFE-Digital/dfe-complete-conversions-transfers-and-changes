class AddInvoluntaryConditionsMet < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :conditions_met_emailed, :boolean
  end
end
