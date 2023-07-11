class ByTeamProjectFetcherService
  def initialize(team)
    @team = team
  end

  def in_progress
    return [] if @team.nil?

    projects = if @team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.in_progress.includes(:assigned_to).by_conversion_date
    else
      Conversion::Project.by_region(@team).in_progress.includes(:assigned_to).by_conversion_date
    end
    pre_fetch_establishments_and_trusts(projects)
  end

  def completed
    return [] if @team.nil?

    projects = if @team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.completed.by_conversion_date
    else
      Conversion::Project.by_region(@team).completed.by_conversion_date
    end

    pre_fetch_establishments_and_trusts(projects)
  end

  def unassigned
    return [] if @team.nil?

    projects = if @team.eql?("regional_casework_services")
      Conversion::Project.assigned_to_regional_caseworker_team.unassigned_to_user.by_conversion_date
    else
      Conversion::Project.by_region(@team).unassigned_to_user.by_conversion_date
    end

    pre_fetch_establishments_and_trusts(projects)
  end

  def users
    return [] if @team.nil?

    @users = User.by_team(@team).compact.map do |user|
      OpenStruct.new(
        name: user.full_name,
        email: user.email,
        id: user.id,
        conversion_count: Conversion::Project.assigned_to(user).count
      )
    end.sort_by { |object| object.name }
  end

  private def pre_fetch_establishments_and_trusts(projects)
    EstablishmentsFetcherService.new(projects).call!
    TrustsFetcherService.new(projects).call!
    projects
  end
end
