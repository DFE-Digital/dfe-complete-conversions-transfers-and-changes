class AddEventsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.references :user, index: true, type: :uuid
      t.references :eventable, type: :uuid, polymorphic: true
      t.integer :grouping, index: true
      t.string :message
      t.timestamps
    end
  end
end
