class AddOutgoingTrustCeoToKeyContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :key_contacts, :outgoing_trust_ceo_id, :uuid
    add_index :key_contacts, :outgoing_trust_ceo_id
  end
end
