class RenameTeamLeader < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :team_leader, :manage_team
  end
end
