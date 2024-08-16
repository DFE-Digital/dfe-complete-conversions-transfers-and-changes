class AddIncomingTrustCeoToKeyContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :key_contacts, :incoming_trust_ceo_id, :uuid
    add_index :key_contacts, :incoming_trust_ceo_id
  end
end
