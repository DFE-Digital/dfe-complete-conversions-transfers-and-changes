class AddDisabledAtToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :disabled_at, :datetime
  end
end
