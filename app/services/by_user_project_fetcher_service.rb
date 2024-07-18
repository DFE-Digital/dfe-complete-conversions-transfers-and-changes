class ByUserProjectFetcherService
  def call
    projects = projects_by_user
    return [] unless projects

    sort_view_objects_by_name(build_view_objects(projects))
  end

  private def projects_by_user
    projects = Project.assigned.active
    return false unless projects.any?

    projects.group_by(&:assigned_to_id)
  end

  private def build_view_objects(projects)
    users = User.where(id: projects.keys)

    users.compact.map do |user|
      OpenStruct.new(
        name: user.full_name,
        email: user.email,
        team: user.team,
        id: user.id,
        conversion_count: projects.fetch(user.id).count { |p| p.type == "Conversion::Project" },
        transfer_count: projects.fetch(user.id).count { |p| p.type == "Transfer::Project" }
      )
    end
  end

  private def sort_view_objects_by_name(view_objects)
    view_objects.sort_by { |view_object| view_object.name }
  end
end
