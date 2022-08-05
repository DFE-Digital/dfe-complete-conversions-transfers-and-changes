class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes, id: :uuid do |t|
      t.text :body

      t.references :project, index: true, foreign_key: true, type: :uuid
      t.references :user, index: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
