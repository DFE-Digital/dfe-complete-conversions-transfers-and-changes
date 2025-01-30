class BackfillLocalAuthorityIdsInProjects < ActiveRecord::Migration[7.1]
  def change
    Project.all.each do |project|
      next if project.local_authority_id.present?

      begin
        project.update_column(:local_authority_id, project.establishment.local_authority.try(:id))
      rescue Api::AcademiesApi::Client::Error => error
        Rails.logger.warn("Migration error: #{error}")
      end
    end
  end
end
