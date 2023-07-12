class RenameUserDeactivatedAtColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :deactived_at, :deactivated_at
  end
end
