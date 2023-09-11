class AddGiasEstablishment < ActiveRecord::Migration[7.0]
  def change
    create_table :gias_establishments, id: :uuid do |t|
      t.integer :urn, index: {unique: true}
      t.integer :ukprn, index: true
      t.string :name, index: true
      t.integer :establishment_number, index: true
      t.string :local_authority_name
      t.integer :local_authority_code, index: true
      t.string :region_name
      t.string :region_code
      t.string :type_name
      t.integer :type_code
      t.integer :age_range_lower
      t.integer :age_range_upper
      t.string :phase_name
      t.integer :phase_code
      t.string :diocese_name
      t.string :diocese_code
      t.string :parliamentary_constituency_name
      t.string :parliamentary_constituency_code
      t.string :address_street
      t.string :address_locality
      t.string :address_additional
      t.string :address_town
      t.string :address_county
      t.string :address_postcode
      t.string :url
      t.timestamps
    end
  end
end
