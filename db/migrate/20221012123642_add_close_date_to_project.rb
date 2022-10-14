class AddCloseDateToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :closed_at, :datetime
  end
end
