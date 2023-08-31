class AddEstablishmentContactIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :establishment_main_contact_id, :uuid
  end
end
