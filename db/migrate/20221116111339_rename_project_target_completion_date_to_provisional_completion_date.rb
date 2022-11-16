class RenameProjectTargetCompletionDateToProvisionalCompletionDate < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :target_completion_date, :provisional_completion_date
  end
end
