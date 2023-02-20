class AddHostMeetingToInvoluntaryConversionProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :stakeholder_kick_off_meeting, :boolean
  end
end
