class CreateConversionInvoluntaryTaskList < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_involuntary_task_lists, id: :uuid do |t|
      t.boolean :handover_review
      t.timestamps
    end
  end
end
