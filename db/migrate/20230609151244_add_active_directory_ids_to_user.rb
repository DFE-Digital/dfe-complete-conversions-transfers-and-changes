class AddActiveDirectoryIdsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active_directory_user_group_ids, :string
  end
end
