class AddOutgoingTrustMainContactIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :outgoing_trust_main_contact_id, :uuid
  end
end
