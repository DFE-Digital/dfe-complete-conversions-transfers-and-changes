class AddConstituencyToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :parliamentary_constituency, :string
  end
end
