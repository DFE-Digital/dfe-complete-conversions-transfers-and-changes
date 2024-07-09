class RemoveSignificantDateHistoryFromNote < ActiveRecord::Migration[7.0]
  def change
    remove_column :notes, :significant_date_history_id, :uuid
  end
end
