class AddInvoluntaryCheckBaselineTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :check_baseline_confirm, :boolean
  end
end
