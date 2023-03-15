class AddConversionDateProvisionalToProjects < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :conversion_date_provisional, :boolean, default: true
    change_column_null :projects, :provisional_conversion_date, true
  end

  def down
    remove_column :projects, :conversion_date_provisional
    change_column_null :projects, :provisional_conversion_date, false
  end
end
