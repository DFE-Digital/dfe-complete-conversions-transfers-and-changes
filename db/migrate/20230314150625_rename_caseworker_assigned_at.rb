class RenameCaseworkerAssignedAt < ActiveRecord::Migration[7.0]
  def up
    Project.all.each do |project|
      if project.caseworker_assigned_at.nil?
        project.caseworker_assigned_at = project.created_at
        project.save(validate: false)
      end
    end

    rename_column :projects, :caseworker_assigned_at, :assigned_at
  end

  def down
    rename_column :projects, :assigned_at, :caseworker_assigned_at
  end
end