class ByLocalAuthorityProjectFetcherService
  def local_authorities_with_projects
    projects = projects_by_local_authority

    if projects
      local_authorities = LocalAuthority.where(code: projects.keys)

      sort_local_authorities_by_name(build_local_authorities_objects(local_authorities, projects))
    end
  end

  def projects_for_local_authority(local_authority_code)
    all_projects.includes(:assigned_to).select { |p| p.establishment.local_authority_code == local_authority_code }
  end

  private def projects_by_local_authority
    all_projects.group_by { |p| p.establishment.local_authority_code }
  end

  private def all_projects
    unless @all_projects
      @all_projects = Project.active.ordered_by_significant_date
      AcademiesApiPreFetcherService.new.call!(@all_projects)
    end

    @all_projects
  end

  private def build_local_authorities_objects(local_authorities, projects)
    return [] unless local_authorities.any? && projects.any?

    local_authorities.map do |local_authority|
      OpenStruct.new(
        name: local_authority.name,
        code: local_authority.code,
        conversion_count: projects.fetch(local_authority.code, []).count { |p| p.type == "Conversion::Project" },
        transfer_count: projects.fetch(local_authority.code, []).count { |p| p.type == "Transfer::Project" }
      )
    end
  end

  private def sort_local_authorities_by_name(local_authority_objects)
    local_authority_objects.sort_by { |local_authority_object| local_authority_object.name }
  end
end
