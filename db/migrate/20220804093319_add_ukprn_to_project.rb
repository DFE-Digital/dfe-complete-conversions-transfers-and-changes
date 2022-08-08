class AddUkprnToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :trust_ukprn, :integer, null: false
  end
end
