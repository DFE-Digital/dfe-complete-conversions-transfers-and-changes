class CreateConversionProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :conversion_projects do |t|

      t.timestamps
    end
  end
end
