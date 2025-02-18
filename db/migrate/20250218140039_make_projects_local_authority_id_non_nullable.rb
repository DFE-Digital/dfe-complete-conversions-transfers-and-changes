class MakeProjectsLocalAuthorityIdNonNullable < ActiveRecord::Migration[7.1]
  def change
    remove_index :projects, :local_authority_id
    change_column_null :projects, :local_authority_id, false
    add_index :projects, :local_authority_id
  end
end
