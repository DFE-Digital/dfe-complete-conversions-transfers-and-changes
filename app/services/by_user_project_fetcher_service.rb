class ByUserProjectFetcherService
  def call
    conversion_counts = conversion_count_by_user
    return [] unless conversion_counts

    sort_view_objects_by_name(build_view_objects(conversion_counts))
  end

  private def conversion_count_by_user
    projects = Conversion::Project.assigned.not_completed
    return false unless projects.any?

    projects.group(:assigned_to_id).count
  end

  private def build_view_objects(conversion_counts)
    users = User.where(id: conversion_counts.keys)

    users.compact.map do |user|
      OpenStruct.new(
        name: user.full_name,
        email: user.email,
        team: user.team,
        id: user.id,
        conversion_count: conversion_counts.fetch(user.id)
      )
    end
  end

  private def sort_view_objects_by_name(view_objects)
    view_objects.sort_by { |view_object| view_object.name }
  end
end
