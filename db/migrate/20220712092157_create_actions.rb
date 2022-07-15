class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions, id: :uuid do |t|
      t.string :title, null: false
      t.integer :order, null: false
      t.boolean :completed, default: false, null: false

      t.references :task, index: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
