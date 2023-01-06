class AddInvoluntaryDeedOfVariation < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :deed_of_variation_received, :boolean
    add_column :conversion_involuntary_task_lists, :deed_of_variation_cleared, :boolean
    add_column :conversion_involuntary_task_lists, :deed_of_variation_signed, :boolean
    add_column :conversion_involuntary_task_lists, :deed_of_variation_saved, :boolean
  end
end
