class AddInvoluntaryUpdateEsfa < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :update_esfa_update, :boolean
  end
end
