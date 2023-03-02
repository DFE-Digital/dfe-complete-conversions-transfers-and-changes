class CreateConversionDateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_date_histories, id: :uuid do |t|
      t.date :revised_date
      t.date :previous_date
      t.uuid :project_id
      t.timestamps
    end

    add_column :notes, :conversion_date_history_id, :uuid
  end
end
