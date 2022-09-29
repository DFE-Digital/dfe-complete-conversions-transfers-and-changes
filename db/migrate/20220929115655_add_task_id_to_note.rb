class AddTaskIdToNote < ActiveRecord::Migration[7.0]
  def change
    add_reference :notes, :task, null: true, foreign_key: {to_table: :tasks}, type: :uuid
  end
end
