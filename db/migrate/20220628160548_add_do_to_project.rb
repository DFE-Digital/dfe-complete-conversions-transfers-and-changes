class AddDoToProject < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :delivery_officer, null: true, foreign_key: {to_table: :users}, type: :uuid
  end
end
