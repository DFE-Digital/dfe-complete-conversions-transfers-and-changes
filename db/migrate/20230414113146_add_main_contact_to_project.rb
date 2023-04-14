class AddMainContactToProject < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :main_contact, null: true, foreign_key: {to_table: :contacts}, type: :uuid
  end
end
