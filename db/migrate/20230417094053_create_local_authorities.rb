class CreateLocalAuthorities < ActiveRecord::Migration[7.0]
  def change
    create_table :local_authorities, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :address_1, null: false
      t.string :address_2
      t.string :address_3
      t.string :address_town
      t.string :address_county
      t.string :address_postcode, null: false

      t.timestamps
    end
  end
end
