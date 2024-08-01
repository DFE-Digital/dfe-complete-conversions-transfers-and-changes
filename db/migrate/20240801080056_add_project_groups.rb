class AddProjectGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :project_groups, id: :uuid do |t|
      t.string :group_identifier, index: true
      t.integer :trust_ukprn, index: true
      t.timestamps
    end

    add_column :projects, :group_id, :uuid, index: true
  end
end
