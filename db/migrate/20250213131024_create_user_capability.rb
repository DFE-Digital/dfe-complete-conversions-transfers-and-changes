class CreateUserCapability < ActiveRecord::Migration[7.1]
  def change
    create_table :user_capabilities, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :capability_id

      t.timestamps
    end
    add_foreign_key :user_capabilities, :capabilities
    add_foreign_key :user_capabilities, :users
    add_index :user_capabilities, :user_id
    add_index :user_capabilities, :capability_id
  end
end
