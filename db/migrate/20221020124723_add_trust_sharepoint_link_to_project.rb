class AddTrustSharepointLinkToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :trust_sharepoint_link, :text
  end
end
