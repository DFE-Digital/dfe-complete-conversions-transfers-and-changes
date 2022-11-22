class ConversionProjectDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_project_details, id: :uuid do |t|
      t.references :project, index: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
