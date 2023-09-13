class AddIncomingTrustMainContactIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :incoming_trust_main_contact_id, :uuid
  end
end
