class AddLastSessionColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :latest_session, :datetime
  end
end
