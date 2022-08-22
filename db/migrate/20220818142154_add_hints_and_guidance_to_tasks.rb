class AddHintsAndGuidanceToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :hint, :text, null: true
    add_column :tasks, :guidance_summary, :string, null: true
    add_column :tasks, :guidance_text, :text, null: true
  end
end
