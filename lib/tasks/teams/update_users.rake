namespace :update_teams do
  desc ">> Update teams information"
  task users: :environment do
    User.all.each do |user|
      UserTeamUpdater.new(user: user).update!
    end
  end
end
