class UpdateProjectDeliveryOfficerIdToCaseworkerId < ActiveRecord::Migration[7.0]
  def change
    remove_reference :projects, :delivery_officer, null: true, foreign_key: {to_table: :users}, type: :uuid
    add_reference :projects, :caseworker, null: true, foreign_key: {to_table: :users}, type: :uuid
  end
end
