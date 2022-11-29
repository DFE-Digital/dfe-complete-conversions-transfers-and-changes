class CreateConversionDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_details, id: :uuid do |t|
      t.string :type
      t.uuid :project_id
      t.timestamps
    end
  end
end
