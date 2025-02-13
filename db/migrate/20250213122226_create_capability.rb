class CreateCapability < ActiveRecord::Migration[7.1]
  def change
    create_table :capabilities, id: :uuid do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end
    add_index :capabilities, :name, unique: true
  end
end
