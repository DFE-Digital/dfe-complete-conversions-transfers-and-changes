class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.integer :urn, null: false # Every URN really is an integer, not a string which only contains numerical characters.
      t.timestamps

      t.index :urn
    end
  end
end
