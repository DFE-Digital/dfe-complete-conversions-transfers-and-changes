class AddAssignedToToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :assigned_to, :uuid

    Project.all.each do |project|
      if project.caseworker_id
        project.update(assigned_to: project.caseworker_id)
      elsif !project.caseworker_id && !project.team_leader_id && project.regional_delivery_officer_id
        project.update(assigned_to: project.regional_delivery_officer_id)
      end
    end
  end
end
