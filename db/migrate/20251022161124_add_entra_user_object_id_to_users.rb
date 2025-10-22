class AddEntraUserObjectIdToUsers < ActiveRecord::Migration[7.1]
  def change
    # Add entra_user_object_id field to users table
    # This field will store Entra ID user object IDs as part of the migration from Active Directory
    add_column :users, :entra_user_object_id, :string, null: true
    
    # Add unique index on entra_user_object_id for non-null values only
    # This allows multiple null values but prevents duplicate GUIDs
    add_index :users, :entra_user_object_id,
      unique: true,
      where: "entra_user_object_id IS NOT NULL",
      name: "UQ_users_entra_user_object_id"
  end
end

