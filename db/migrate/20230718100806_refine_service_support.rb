class RefineServiceSupport < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :manage_conversion_urns, :boolean, default: false
    add_column :users, :manage_local_authorities, :boolean, default: false
    rename_column :users, :service_support, :manage_user_accounts
  end
end
