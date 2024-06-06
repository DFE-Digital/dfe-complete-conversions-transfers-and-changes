class CreateSignificantDateHistoryReason < ActiveRecord::Migration[7.0]
  def change
    create_table :significant_date_history_reasons, id: :uuid do |t|
      t.timestamps
      t.string :reason_type, index: true
      t.uuid :significant_date_history_id
    end

    add_column :notes, :significant_date_history_reason_id, :uuid
  end
end
