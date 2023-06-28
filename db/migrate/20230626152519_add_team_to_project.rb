class AddTeamToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :team, :string
  end
end
