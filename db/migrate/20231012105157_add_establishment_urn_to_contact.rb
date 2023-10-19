class AddEstablishmentUrnToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :establishment_urn, :integer
    add_index :contacts, :establishment_urn
  end
end
