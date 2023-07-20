class RenameRegionalDeliveryOfficer < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :regional_delivery_officer, :add_new_project
  end
end
