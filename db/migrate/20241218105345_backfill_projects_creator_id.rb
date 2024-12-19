class BackfillProjectsCreatorId < ActiveRecord::Migration[7.1]
  def change
    Project.all.each do |project|
      next if project.creator_id.present?

      project.update_column(:creator_id, project.regional_delivery_officer_id)
    end
  end
end
