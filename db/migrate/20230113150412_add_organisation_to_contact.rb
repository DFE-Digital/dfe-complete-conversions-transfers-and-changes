class AddOrganisationToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :organisation_name, :string
  end
end
