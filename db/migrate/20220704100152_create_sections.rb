class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections, id: :uuid do |t|
      t.string :title, null: false
      t.integer :order, null: false

      t.references :project, index: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
