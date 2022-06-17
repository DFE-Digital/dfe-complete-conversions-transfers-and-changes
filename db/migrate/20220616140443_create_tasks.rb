class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.integer :order, null: false
      t.boolean :completed, default: false, null: false

      t.references :section, index: true, foreign_key: true

      t.timestamps
    end
  end
end
