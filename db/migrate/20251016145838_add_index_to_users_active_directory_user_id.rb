class AddIndexToUsersActiveDirectoryUserId < ActiveRecord::Migration[7.1]
  def change
    # Add non-unique index on active_directory_user_id for query performance
    # Only index non-null values to optimize storage
    add_index :users, :active_directory_user_id,
      where: "active_directory_user_id IS NOT NULL",
      name: "index_users_on_active_directory_user_id"
  end
end

