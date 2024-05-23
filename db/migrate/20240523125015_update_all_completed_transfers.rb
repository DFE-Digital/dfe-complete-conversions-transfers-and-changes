class UpdateAllCompletedTransfers < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.transaction do
      Transfer::Project.all.each do |project|
        if project.all_conditions_met?
          tasks_data = project.tasks_data
          tasks_data.update(
            conditions_met_check_any_information_changed: true,
            conditions_met_baseline_sheet_approved: true
          )
        end
      end
    end
  end
end
