class AddMainContactToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :main_contact_id, :uuid
  end
end
