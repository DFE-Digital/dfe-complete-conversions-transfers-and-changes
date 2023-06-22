class ByTrustProjectFetcherService
  def call
    conversion_counts = conversion_count_by_trust

    if conversion_counts
      trusts = get_trusts(conversion_counts.keys)

      sort_trust_objects_by_name(build_trust_objects(trusts, conversion_counts))
    else
      []
    end
  end

  private def conversion_count_by_trust
    projects = Conversion::Project.not_completed
    return false unless projects.any?

    projects.group(:incoming_trust_ukprn).count
  end

  private def get_trusts(ukprns)
    client = Api::AcademiesApi::Client.new
    client.get_trusts(ukprns).object
  end

  private def build_trust_objects(trusts, conversion_counts)
    return [] unless trusts.present? && conversion_counts

    trusts.map do |trust|
      OpenStruct.new(
        name: trust.name,
        ukprn: trust.ukprn,
        group_id: trust.group_identifier,
        conversion_count: conversion_counts.fetch(trust.ukprn.to_i)
      )
    end
  end

  private def sort_trust_objects_by_name(trust_objects)
    trust_objects.sort_by { |trust_object| trust_object.name }
  end
end
