class RemoveConversionDetails < ActiveRecord::Migration[7.0]
  def change
    drop_table :conversion_details
  end
end
