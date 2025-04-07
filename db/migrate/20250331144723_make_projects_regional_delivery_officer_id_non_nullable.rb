class MakeProjectsRegionalDeliveryOfficerIdNonNullable < ActiveRecord::Migration[7.1]
  def change
    remove_index :projects, :regional_delivery_officer_id
    change_column_null :projects, :regional_delivery_officer_id, false
    add_index :projects, :regional_delivery_officer_id
  end
end
