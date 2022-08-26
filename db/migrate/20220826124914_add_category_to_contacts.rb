class AddCategoryToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :category, :integer, null: false, default: 0
    add_index :contacts, :category
  end
end
