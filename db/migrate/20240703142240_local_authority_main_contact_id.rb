class LocalAuthorityMainContactId < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :local_authority_main_contact_id, :uuid
  end
end
