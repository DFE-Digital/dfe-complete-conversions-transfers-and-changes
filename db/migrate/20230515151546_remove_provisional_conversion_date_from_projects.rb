class RemoveProvisionalConversionDateFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :provisional_conversion_date, :date
  end
end
