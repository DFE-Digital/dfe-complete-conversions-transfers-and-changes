class AddUniqueProjectIndexOnUrnAndState < ActiveRecord::Migration[7.1]
  def change
    add_index :projects, [:urn, :state], unique: true
  end
end
