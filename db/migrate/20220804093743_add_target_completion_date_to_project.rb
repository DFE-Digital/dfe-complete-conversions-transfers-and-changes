class AddTargetCompletionDateToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :target_completion_date, :date, null: false
  end
end
