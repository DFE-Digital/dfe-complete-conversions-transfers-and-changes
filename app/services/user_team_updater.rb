class UserTeamUpdater
  class UserTeamError < StandardError; end

  def initialize(user:)
    @user = user
  end

  def update!
    @user.update!(team: "service_support") if @user.service_support?
    @user.update!(team: "regional_casework_services") if @user.caseworker? || @user.team_leader?
  rescue ActiveRecord::RecordInvalid
    raise UserTeamError.new("Unable to update team for user #{@user.id}")
  end
end
