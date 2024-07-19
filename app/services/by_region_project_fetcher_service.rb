class ByRegionProjectFetcherService
  def project_counts
    projects = projects_by_region

    if projects
      sort_view_objects_by_name(build_view_objects(projects))
    else
      []
    end
  end

  def regional_casework_services_projects(region)
    Project.active.by_region(region).assigned_to_regional_caseworker_team.includes(:assigned_to).ordered_by_significant_date
  end

  private def projects_by_region
    projects = Project.active
    return false unless projects.any?

    projects.group_by(&:region)
  end

  private def build_view_objects(projects)
    return [] unless projects.any?

    projects.keys.map do |region|
      OpenStruct.new(
        name: region,
        conversion_count: projects[region].count { |p| p.type == "Conversion::Project" },
        transfer_count: projects[region].count { |p| p.type == "Transfer::Project" }
      )
    end
  end

  private def sort_view_objects_by_name(view_objects)
    view_objects.sort_by { |view_object| view_object.name }
  end
end
