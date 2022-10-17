class AddPaddingToAction < ActiveRecord::Migration[7.0]
  def change
    add_column :actions, :padding, :string, default: "normal"
  end
end
