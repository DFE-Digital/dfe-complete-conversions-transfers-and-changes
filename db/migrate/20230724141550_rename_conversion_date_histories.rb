class RenameConversionDateHistories < ActiveRecord::Migration[7.0]
  def change
    rename_table :conversion_date_histories, :significant_date_histories

    rename_column :notes, :conversion_date_history_id, :significant_date_history_id
  end
end
