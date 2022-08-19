class AddRegionalDeliveryOfficerToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :regional_delivery_officer, :boolean, null: false, default: false
    add_reference :projects, :regional_delivery_officer, null: false, foreign_key: {to_table: :users}, type: :uuid
  end
end
