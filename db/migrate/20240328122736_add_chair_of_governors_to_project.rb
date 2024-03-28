class AddChairOfGovernorsToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :chair_of_governors_contact_id, :uuid
  end
end
