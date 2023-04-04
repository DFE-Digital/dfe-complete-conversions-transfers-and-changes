class AddAcademyUrnToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :academy_urn, :integer
  end
end
