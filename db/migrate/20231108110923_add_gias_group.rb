class AddGiasGroup < ActiveRecord::Migration[7.0]
  def change
    create_table :gias_groups, id: :uuid do |t|
      t.integer :ukprn, index: true
      t.integer :unique_group_identifier, index: {unique: true}
      t.string :group_identifier, index: true
      t.string :original_name
      t.string :companies_house_number
      t.string :address_street
      t.string :address_locality
      t.string :address_additional
      t.string :address_town
      t.string :address_county
      t.string :address_postcode
      t.timestamps
    end
  end
end
