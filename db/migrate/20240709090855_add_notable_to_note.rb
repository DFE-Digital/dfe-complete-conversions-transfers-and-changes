class AddNotableToNote < ActiveRecord::Migration[7.0]
  def up
    change_table :notes do |t|
      t.rename :significant_date_history_reason_id, :notable_id
      t.string :notable_type
      t.index [:notable_id, :notable_type]
    end

    Note.all.each do |note|
      if note.notable_id.present?
        note.notable_type = "SignificantDateHistoryReason"
        note.save(validate: false)
      end
    end
  end

  def down
    change_table :notes do |t|
      t.rename :notable_id, :significant_date_history_reason_id
    end

    remove_column :notes, :notable_type
  end
end
