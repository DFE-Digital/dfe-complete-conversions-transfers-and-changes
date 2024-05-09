class RemoveTeamLeaderFromProject < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :team_leader_id, :uuid
  end
end
