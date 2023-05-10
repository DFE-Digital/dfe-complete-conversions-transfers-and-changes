class AddServiceSupportToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :service_support, :boolean, default: false
  end
end
