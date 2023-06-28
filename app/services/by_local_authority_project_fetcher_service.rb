class ByLocalAuthorityProjectFetcherService
  def call
    conversion_counts = conversions_count_by_local_authority

    if conversion_counts
      local_authorities = LocalAuthority.where(code: conversion_counts.keys)

      sort_local_authorities_by_name(build_local_authorities_objects(local_authorities, conversion_counts))
    end
  end

  private def conversions_count_by_local_authority
    projects = Project.not_completed.select(:id, :urn)

    EstablishmentsFetcher.new.call(projects)

    projects.group_by { |p| p.establishment.local_authority_code }
  end

  private def build_local_authorities_objects(local_authorities, conversion_counts)
    return [] unless local_authorities.any? && conversion_counts.any?

    local_authorities.map do |local_authority|
      OpenStruct.new(
        name: local_authority.name,
        code: local_authority.code,
        conversion_count: conversion_counts.fetch(local_authority.code).count
      )
    end
  end

  private def sort_local_authorities_by_name(local_authority_objects)
    local_authority_objects.sort_by { |local_authority_object| local_authority_object.name }
  end
end
