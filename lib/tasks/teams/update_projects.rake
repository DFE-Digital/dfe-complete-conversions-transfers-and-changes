namespace :update_teams do
  desc ">> Update teams information"
  task projects: :environment do
    Project.all.each do |project|
      ProjectTeamUpdater.new(project: project).update!
    end
  end
end
