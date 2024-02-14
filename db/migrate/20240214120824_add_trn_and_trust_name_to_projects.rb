class AddTrnAndTrustNameToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :new_trust_reference_number, :string
    add_column :projects, :new_trust_name, :string
  end
end
