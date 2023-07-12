class AddDeactivatedAtToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deactived_at, :datetime
  end
end
