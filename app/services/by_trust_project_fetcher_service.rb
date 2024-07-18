class ByTrustProjectFetcherService
  def call
    projects = projects_by_trust

    if projects
      trusts = get_trusts(projects.keys)

      sort_trust_objects_by_name(build_trust_objects(trusts, projects))
    else
      []
    end
  end

  private def projects_by_trust
    projects = Project.active.not_form_a_mat
    return false unless projects.any?

    projects.group_by(&:incoming_trust_ukprn)
  end

  private def get_trusts(ukprns)
    client = Api::AcademiesApi::Client.new
    client.get_trusts(ukprns).object
  end

  private def build_trust_objects(trusts, projects)
    return [] unless trusts.present? && projects

    trusts.map do |trust|
      OpenStruct.new(
        name: trust.name,
        ukprn: trust.ukprn,
        group_id: trust.group_identifier,
        conversion_count: projects.fetch(trust.ukprn.to_i).count { |p| p.type == "Conversion::Project" },
        transfer_count: projects.fetch(trust.ukprn.to_i).count { |p| p.type == "Transfer::Project" }
      )
    end
  end

  private def sort_trust_objects_by_name(trust_objects)
    trust_objects.sort_by { |trust_object| trust_object.name }
  end
end
