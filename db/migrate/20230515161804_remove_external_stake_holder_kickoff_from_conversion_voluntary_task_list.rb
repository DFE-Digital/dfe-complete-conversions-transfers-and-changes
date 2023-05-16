class RemoveExternalStakeHolderKickoffFromConversionVoluntaryTaskList < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :stakeholder_kick_off_confirmed_conversion_date, :date
  end
end
