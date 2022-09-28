class AddEstablishmentSharepointLinkToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :establishment_sharepoint_link, :text
  end
end
