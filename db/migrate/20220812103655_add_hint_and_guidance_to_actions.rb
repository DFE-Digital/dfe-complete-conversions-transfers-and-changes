class AddHintAndGuidanceToActions < ActiveRecord::Migration[7.0]
  def change
    add_column :actions, :hint, :text, null: true
    add_column :actions, :guidance_summary, :string, null: true
    add_column :actions, :guidance_text, :text, null: true
  end
end
