class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string :title, null: false
      t.integer :order, null: false

      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
