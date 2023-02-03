class AddAssignedToToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :assigned_to, foreign_key: {to_table: :users}, type: :uuid

    Project.all.each do |project|
      if project.caseworker_id
        project.update!(assigned_to_id: project.caseworker_id)
      elsif project.regional_delivery_officer_id
        project.update!(assigned_to_id: project.regional_delivery_officer_id)
      end
    end
  end
end
