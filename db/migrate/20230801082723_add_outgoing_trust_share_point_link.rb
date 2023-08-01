class AddOutgoingTrustSharePointLink < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :outgoing_trust_sharepoint_link, :text
  end
end
