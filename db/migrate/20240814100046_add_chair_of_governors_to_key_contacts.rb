class AddChairOfGovernorsToKeyContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :key_contacts, :chair_of_governors_id, :uuid
    add_index :key_contacts, :chair_of_governors_id
  end
end
