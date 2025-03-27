class MakeProjectsRegionNonNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :projects, :region, false
    add_index :projects, :region
  end
end
