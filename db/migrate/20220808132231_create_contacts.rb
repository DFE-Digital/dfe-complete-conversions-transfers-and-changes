class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.references :project, index: true, foreign_key: true, type: :uuid

      t.string :name, null: false
      t.string :title, null: false

      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
