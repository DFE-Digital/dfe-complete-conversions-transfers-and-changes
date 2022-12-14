class AddConversionVoluntaryTaskLists < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_voluntary_task_lists, id: :uuid do |t|
      t.boolean :handover_review
      t.boolean :handover_notes
      t.boolean :handover_meeting

      t.timestamps
    end
  end
end
