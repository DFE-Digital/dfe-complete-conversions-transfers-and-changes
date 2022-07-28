class AddTeamLeaderIdToProject < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :team_leader, null: false, foreign_key: {to_table: :users}, type: :uuid
  end
end
