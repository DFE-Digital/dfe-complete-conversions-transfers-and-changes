class AddActiveDirectoryUserIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active_directory_user_id, :string
  end
end
