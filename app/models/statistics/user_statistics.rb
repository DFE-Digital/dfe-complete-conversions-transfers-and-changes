class Statistics::UserStatistics
  include Teamable

  def initialize
    @users = User.all
  end

  def users_count_per_team
    result = {}
    USER_TEAMS.each do |key, value|
      result[key] = @users.by_team(value).count
    end
    result
  end
end
