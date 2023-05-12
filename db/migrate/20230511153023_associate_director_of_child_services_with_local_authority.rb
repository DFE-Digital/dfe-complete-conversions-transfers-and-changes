class AssociateDirectorOfChildServicesWithLocalAuthority < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :local_authority_id, :uuid
    add_column :contacts, :type, :string
  end
end
