class ProjectSearchService
  def search(query)
    if urn_pattern(query)
      return search_by_urns(query)
    end

    if ukprn_pattern(query)
      return search_by_ukprn(query)
    end

    []
  end

  def search_by_urns(urns)
    Project.where(urn: urns)
  end

  def search_by_ukprn(ukprn)
    Project.where("incoming_trust_ukprn = ?", ukprn)
      .or(Project.where("outgoing_trust_ukprn = ?", ukprn))
  end

  private def urn_pattern(query)
    query.match?(/^\d{6}$/)
  end

  private def ukprn_pattern(query)
    query.match?(/^\d{8}$/)
  end
end
