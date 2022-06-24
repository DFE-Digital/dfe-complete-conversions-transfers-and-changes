class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    
    create_table :projects, id: :uuid do |t|
      t.integer :urn # Every URN really is an integer, not a string which only contains numerical characters.
      t.timestamps
    end
  end
end
