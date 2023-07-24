class RenameConversionDate < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :conversion_date, :significant_date
    rename_column :projects, :conversion_date_provisional, :significant_date_provisional
  end
end
