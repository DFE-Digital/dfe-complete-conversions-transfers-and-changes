class RenameCaseworkerAssignedAt < ActiveRecord::Migration[7.0]
  def change
    Project.all.each do |project|
      if project.caseworker_assigned_at.nil?
        project.update!(caseworker_assigned_at: project.created_at)
      end
    end

    rename_column :projects, :caseworker_assigned_at, :assigned_at
  end
end
