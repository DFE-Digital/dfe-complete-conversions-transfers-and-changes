class AddConstituencyIdToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :constituency_id, :integer
  end
end
