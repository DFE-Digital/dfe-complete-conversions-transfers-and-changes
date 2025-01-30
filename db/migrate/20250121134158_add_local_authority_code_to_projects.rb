class AddLocalAuthorityCodeToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :local_authority_id, :uuid
    add_index :projects, :local_authority_id
  end
end
