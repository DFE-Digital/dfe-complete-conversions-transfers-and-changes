class ByRegionProjectFetcherService
  def conversion_counts
    conversion_counts = conversion_count_by_region

    if conversion_counts
      sort_view_objects_by_name(build_view_objects(conversion_counts))
    else
      []
    end
  end

  private def conversion_count_by_region
    projects = Conversion::Project.not_completed
    return false unless projects.any?

    projects.group(:region).count
  end

  private def build_view_objects(conversion_counts)
    return [] unless conversion_counts.any?

    conversion_counts.keys.map do |region|
      OpenStruct.new(
        name: region,
        conversion_count: conversion_counts.fetch(region)
      )
    end
  end

  private def sort_view_objects_by_name(view_objects)
    view_objects.sort_by { |view_object| view_object.name }
  end
end
