class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.timestamps
      t.string :api_key, null: false
      t.datetime :expires_at, null: false
      t.string :description
    end
  end
end
