class AddAcademyNameToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :academy_name, :string
  end
end
