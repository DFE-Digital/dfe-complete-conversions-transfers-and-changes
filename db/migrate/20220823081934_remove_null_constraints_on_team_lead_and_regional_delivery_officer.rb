class RemoveNullConstraintsOnTeamLeadAndRegionalDeliveryOfficer < ActiveRecord::Migration[7.0]
  def change
    change_column_null :projects, :team_leader_id, true
    change_column_null :projects, :regional_delivery_officer_id, true
  end
end
