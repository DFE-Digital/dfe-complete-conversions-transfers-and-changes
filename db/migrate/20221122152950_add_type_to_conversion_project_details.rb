class AddTypeToConversionProjectDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_project_details, :type, :string
  end
end
