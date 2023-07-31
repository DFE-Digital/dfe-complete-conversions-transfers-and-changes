class RenameTrustSharePointLink < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :trust_sharepoint_link, :incoming_trust_sharepoint_link
  end
end
