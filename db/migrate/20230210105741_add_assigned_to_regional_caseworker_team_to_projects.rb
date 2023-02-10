class AddAssignedToRegionalCaseworkerTeamToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :assigned_to_regional_caseworker_team, :boolean, default: false
  end
end
